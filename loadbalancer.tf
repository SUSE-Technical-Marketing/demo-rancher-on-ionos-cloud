# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

resource "ionoscloud_networkloadbalancer" "lb_rancher" {
  datacenter_id = ionoscloud_datacenter.vdc.id
  name          = "Rancher Manager Load Balancer"
  listener_lan  = ionoscloud_lan.public.id
  target_lan    = ionoscloud_lan.private.id
  ips           = [ionoscloud_ipblock.ip_lb_rancher.ips[0]]

  # default, added automatically when an NLB is created
  # set here to avoid constant changes to the lb resource
  logging_format = "%ci:%cp [%t] %ft %b/%s %Tw/%Tc/%Tt %B %ts %ac/%fc/%bc/%sc/%rc %sq/%bq"
}

locals {
  lb_rancher_target_ips = concat(
    [ionoscloud_nic.private_nic_first.ips[0]],
    [for nic in ionoscloud_nic.private_nic : nic.ips[0]]
  )
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

resource "ionoscloud_networkloadbalancer_forwardingrule" "lb_rancher_rule3" {
  datacenter_id          = ionoscloud_datacenter.vdc.id
  networkloadbalancer_id = ionoscloud_networkloadbalancer.lb_rancher.id
  name                   = "Rancher Manager - RKE2"
  algorithm              = "SOURCE_IP"
  protocol               = "TCP"
  listener_ip            = ionoscloud_ipblock.ip_lb_rancher.ips[0]
  listener_port          = "9345"
  dynamic "targets" {
    for_each = local.lb_rancher_target_ips
    content {
      ip     = targets.value
      port   = "9345"
      weight = "1"
      health_check {
        check          = true
        check_interval = 1000
        maintenance    = false
      }
    }
  }
}

resource "ionoscloud_networkloadbalancer_forwardingrule" "lb_rancher_rule4" {
  datacenter_id          = ionoscloud_datacenter.vdc.id
  networkloadbalancer_id = ionoscloud_networkloadbalancer.lb_rancher.id
  name                   = "Rancher Manager - K8S API"
  algorithm              = "SOURCE_IP"
  protocol               = "TCP"
  listener_ip            = ionoscloud_ipblock.ip_lb_rancher.ips[0]
  listener_port          = "6443"
  dynamic "targets" {
    for_each = local.lb_rancher_target_ips
    content {
      ip     = targets.value
      port   = "6443"
      weight = "1"
      health_check {
        check          = true
        check_interval = 1000
        maintenance    = false
      }
    }
  }
}
