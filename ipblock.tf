# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

resource "ionoscloud_ipblock" "ip_lb_rancher" {
  location = var.datacenter_location
  size     = 1
  name     = "IP Block for Rancher Load Balancer"
}

resource "ionoscloud_ipblock" "ip_server_rancher_first" {
  location = var.datacenter_location
  size     = 1
  name     = "IP Block for first Rancher Server"
}
