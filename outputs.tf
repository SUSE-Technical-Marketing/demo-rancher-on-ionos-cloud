# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

output "server_rancher_first" {
  value = [
    {
      ip = ionoscloud_server.server_rancher_first.primary_ip

      ip_private = ionoscloud_nic.private_nic[0].ips[0]

      dns = join(".", [
        ionoscloud_server.server_rancher_first.name,
        ionoscloud_server.server_rancher_first.primary_ip,
        "sslip.io"
      ])
    }
  ]
}

output "server_rancher_additional" {
  value = [
    for i in range(length(ionoscloud_server.server_rancher_additional)) :
    {
      ip = ionoscloud_server.server_rancher_additional[i].primary_ip

      ip_private = ionoscloud_nic.private_nic[i].ips[0]

      dns = join(".", [
        ionoscloud_server.server_rancher_additional[i].name,
        ionoscloud_server.server_rancher_additional[i].primary_ip,
        "sslip.io"
      ])
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
