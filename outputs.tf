# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

output "server_rancher_ips" {
  value = [
    for i in ionoscloud_server.server_rancher[*] :
    {
      ip  = i.primary_ip
      dns = join(".", [i.name, i.primary_ip, "sslip.io"])
    }
  ]
}

output "sles_image_password" {
  value     = random_password.sles_image_password
  sensitive = true
}

output "rancher_loadbalancer" {
  value = [
    {
      ip  = ionoscloud_networkloadbalancer.lb_rancher.ips[0]
      dns = join(".", ["rancher", ionoscloud_networkloadbalancer.lb_rancher.ips[0], "sslip.io"])
    }
  ]

}
