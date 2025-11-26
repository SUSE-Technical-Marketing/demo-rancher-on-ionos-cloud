# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

output "server_rancher_ips" {
  value = [
    for i in ionoscloud_server.server_rancher[*] :
    {
      primary_ip = i.primary_ip
      dns_name   = join(".", [i.name, i.primary_ip, "sslip.io"])
    }
  ]
}
