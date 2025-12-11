# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

output "server_rancher_first" {
  description = "Public, Private IP and DNS name of the first Rancher Node"
  value = [
    {
      ip = ionoscloud_server.server_rancher_first.primary_ip

      ip_private = ionoscloud_nic.private_nic_first.ips[0]

      dns = join(".", [
        ionoscloud_server.server_rancher_first.name,
        ionoscloud_server.server_rancher_first.primary_ip,
        "sslip.io"
      ])
    }
  ]
}

output "server_rancher_additional" {
  description = "Public, Private IP and DNS name of the additional Rancher Nodes"
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
  description = "root User Password for SSH access as backup to ssh keys"
  value       = random_password.sles_image_password
  sensitive   = true
}

output "rancher_loadbalancer" {
  description = "Public IP and DNS name of the Load Balancer in front of the Rancher Manager Cluster"
  value = [
    {
      ip  = ionoscloud_networkloadbalancer.lb_rancher.ips[0]
      dns = join(".", ["rancher", ionoscloud_networkloadbalancer.lb_rancher.ips[0], "sslip.io"])
    }
  ]
}
