# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

resource "ionoscloud_lan" "public" {
  datacenter_id = ionoscloud_datacenter.vdc.id
  public        = true
  name          = var.lan_public_name
}

resource "ionoscloud_lan" "private" {
  datacenter_id = ionoscloud_datacenter.vdc.id
  public        = false
  name          = var.lan_private_name
}

resource "ionoscloud_ipblock" "ip_lb_rancher" {
  location = var.datacenter_location
  size     = 1
  name     = "IP Block for Rancher Load Balancer"
}
