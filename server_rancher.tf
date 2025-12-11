# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

resource "ionoscloud_server" "server_rancher_first" {
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
    ips  = [ionoscloud_ipblock.ip_server_rancher_first.ips[0]]
  }
}

resource "ionoscloud_nic" "private_nic_first" {
  name          = "private"
  datacenter_id = ionoscloud_datacenter.vdc.id
  lan           = ionoscloud_lan.private.id
  server_id     = ionoscloud_server.server_rancher_first.id
}

resource "ionoscloud_server" "server_rancher_additional" {
  count      = 2
  depends_on = [ionoscloud_nic.private_nic_first]

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
