# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

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
  volume {
    name              = "system"
    size              = 600
    disk_type         = "SSD Premium"
    bus               = "VIRTIO"
    availability_zone = "AUTO"
  }
  nic {
    lan  = ionoscloud_lan.public.id
    name = "system"
    dhcp = true
    ips  = []

  }
}
