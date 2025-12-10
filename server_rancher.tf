# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

resource "random_password" "token" {
  length  = 40
  special = false
}

module "rke2_first" {
  source       = "./tf-rancher-up/modules/distribution/rke2"
  rke2_token   = random_password.token.result
  rke2_version = var.rke2_version
  rke2_config  = <<-EOT
      - ${join(".", ["rancher", ionoscloud_networkloadbalancer.lb_rancher.ips[0], "sslip.io"])}
      - ${ionoscloud_networkloadbalancer.lb_rancher.ips[0]}
    ${var.rke2_config == null ? "" : var.rke2_config}
  EOT
}

module "rke2_additional" {
  source          = "./tf-rancher-up/modules/distribution/rke2"
  rke2_token      = random_password.token.result
  rke2_version    = var.rke2_version
  rke2_config     = <<-EOT
      - ${join(".", ["rancher", ionoscloud_networkloadbalancer.lb_rancher.ips[0], "sslip.io"])}
      - ${ionoscloud_networkloadbalancer.lb_rancher.ips[0]}
    ${var.rke2_config == null ? "" : var.rke2_config}
  EOT
  first_server_ip = ionoscloud_networkloadbalancer.lb_rancher.ips[0]
}

data "cloudinit_config" "server_rancher_first" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "rke2.sh"
    content_type = "text/x-shellscript"

    content = module.rke2_first.rke2_user_data
  }

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = <<-EOT
      #cloud-config
      hostname: rancher0
      create_hostname_file: true
      prefer_fqdn_over_hostname: false

      runcmd:
      - SUSEConnect -r ${var.scc_registration_code} -e ${var.scc_registration_email}
      - zypper ref && zypper --non-interactive in iptables
      - zypper --non-interactive dup
    EOT
  }
}

resource "ionoscloud_server" "server_rancher_first" {
  depends_on = [ionoscloud_networkloadbalancer.lb_rancher]

  name              = "rancher0"
  datacenter_id     = ionoscloud_datacenter.vdc.id
  cores             = var.server_rancher_cpu_cores
  ram               = var.server_rancher_ram
  image_name        = data.ionoscloud_image.sles.name
  image_password    = random_password.sles_image_password.result
  type              = "ENTERPRISE"
  availability_zone = "AUTO"
  ssh_keys          = var.server_ssh_keys
  allow_replace     = true
  volume {
    name              = "system0"
    size              = var.server_rancher_disk_size
    disk_type         = "SSD Premium"
    bus               = "VIRTIO"
    availability_zone = "AUTO"
    user_data         = data.cloudinit_config.server_rancher_first.rendered
  }
  nic {
    lan  = ionoscloud_lan.public.id
    name = "public"
    dhcp = true
  }
}

resource "ionoscloud_nic" "private_nic_first" {
  name          = "private"
  datacenter_id = ionoscloud_datacenter.vdc.id
  lan           = ionoscloud_lan.private.id
  server_id     = ionoscloud_server.server_rancher_first.id
}

data "cloudinit_config" "server_rancher_additional" {
  count = 2

  gzip          = false
  base64_encode = true

  part {
    filename     = "rke2.sh"
    content_type = "text/x-shellscript"

    content = module.rke2_additional.rke2_user_data
  }

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = <<-EOT
      #cloud-config
      hostname: rancher${count.index + 1}
      create_hostname_file: true
      prefer_fqdn_over_hostname: false

      runcmd:
      - SUSEConnect -r ${var.scc_registration_code} -e ${var.scc_registration_email}
      - zypper ref && zypper --non-interactive in iptables
      - zypper --non-interactive dup
    EOT
  }
}

resource "ionoscloud_server" "server_rancher_additional" {
  count      = 2
  depends_on = [module.rke2_first]

  name              = "rancher${count.index + 1}"
  datacenter_id     = ionoscloud_datacenter.vdc.id
  cores             = var.server_rancher_cpu_cores
  ram               = var.server_rancher_ram
  image_name        = data.ionoscloud_image.sles.name
  image_password    = random_password.sles_image_password.result
  type              = "ENTERPRISE"
  availability_zone = "AUTO"
  ssh_keys          = var.server_ssh_keys
  allow_replace     = true
  volume {
    name              = "system${count.index + 1}"
    size              = var.server_rancher_disk_size
    disk_type         = "SSD Premium"
    bus               = "VIRTIO"
    availability_zone = "AUTO"
    user_data         = data.cloudinit_config.server_rancher_additional[count.index].rendered
  }
  nic {
    lan  = ionoscloud_lan.public.id
    name = "public"
    dhcp = true
  }
}

resource "ionoscloud_nic" "private_nic" {
  count = 2

  name          = "private"
  datacenter_id = ionoscloud_datacenter.vdc.id
  lan           = ionoscloud_lan.private.id
  server_id     = ionoscloud_server.server_rancher_additional[count.index].id
}
