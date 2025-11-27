# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

resource "random_password" "token" {
  length  = 40
  special = false
}

module "rke2" {
  source          = "./tf-rancher-up/modules/distribution/rke2"
  rke2_token      = random_password.token.result
  rke2_version    = var.rke2_version
  rke2_config     = var.rke2_config
  first_server_ip = ionoscloud_ipblock.ip_lb_rancher.ips[0]
}

resource "ionoscloud_server" "server_rancher" {
  count = 3

  name              = "rancher${count.index}"
  datacenter_id     = ionoscloud_datacenter.vdc.id
  cores             = 4
  ram               = 16384
  image_name        = data.ionoscloud_image.sles.name
  image_password    = random_password.sles_image_password.result
  type              = "ENTERPRISE"
  availability_zone = "AUTO"
  ssh_keys          = var.server_ssh_keys
  allow_replace     = true
  volume {
    name              = "system"
    size              = 600
    disk_type         = "SSD Premium"
    bus               = "VIRTIO"
    availability_zone = "AUTO"
    user_data = base64encode(<<EOF
#cloud-config
hostname: rancher${count.index}
create_hostname_file: true
prefer_fqdn_over_hostname: false

write_files:
  - path: /run/scripts/rke2.sh
    content: ${module.rke2.rke2_user_data}

runcmd:
- SUSEConnect -r ${var.scc_registration_code} -e ${var.scc_registration_email}
- [ sh, "/run/scripts/test-script.sh" ]
- zypper ref && zypper --non-interactive dup
- reboot
EOF
    )
  }
  nic {
    lan  = ionoscloud_lan.public.id
    name = "private"
    dhcp = true
  }
}
