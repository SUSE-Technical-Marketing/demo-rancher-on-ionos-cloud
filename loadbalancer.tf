# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

resource "ionoscloud_networkloadbalancer" "lb_rancher" {
  datacenter_id = ionoscloud_datacenter.vdc.id
  name          = "Rancher Manager Load Balancer"
  listener_lan  = ionoscloud_lan.public.id
  target_lan    = ionoscloud_lan.private.id
  ips           = [ionoscloud_ipblock.ip_lb_rancher.ips[0]]
}

locals {
  lb_rancher_target_ips = [for i in ionoscloud_server.server_rancher[*] : i.primary_ip]
}

resource "ionoscloud_networkloadbalancer_forwardingrule" "lb_rancher_rule1" {
  datacenter_id          = ionoscloud_datacenter.vdc.id
  networkloadbalancer_id = ionoscloud_networkloadbalancer.lb_rancher.id
  name                   = "Rancher Manager - https"
  algorithm              = "SOURCE_IP"
  protocol               = "TCP"
  listener_ip            = ionoscloud_ipblock.ip_lb_rancher.ips[0]
  listener_port          = "443"
  dynamic "targets" {
    for_each = local.lb_rancher_target_ips
    content {
      ip     = targets.value
      port   = "443"
      weight = "1"
      health_check {
        check          = true
        check_interval = 1000
        maintenance    = false
      }
    }
  }
}

resource "ionoscloud_networkloadbalancer_forwardingrule" "lb_rancher_rule2" {
  datacenter_id          = ionoscloud_datacenter.vdc.id
  networkloadbalancer_id = ionoscloud_networkloadbalancer.lb_rancher.id
  name                   = "Rancher Manager - http"
  algorithm              = "SOURCE_IP"
  protocol               = "TCP"
  listener_ip            = ionoscloud_ipblock.ip_lb_rancher.ips[0]
  listener_port          = "80"
  dynamic "targets" {
    for_each = local.lb_rancher_target_ips
    content {
      ip     = targets.value
      port   = "80"
      weight = "1"
      health_check {
        check          = true
        check_interval = 1000
        maintenance    = false
      }
    }
  }
}
