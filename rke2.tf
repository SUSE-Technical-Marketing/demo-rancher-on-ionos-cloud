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
