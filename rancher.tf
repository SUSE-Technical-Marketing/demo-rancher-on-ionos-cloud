# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

locals {
  kc_file = pathexpand("${path.cwd}/${join(".", ["rancher", ionoscloud_networkloadbalancer.lb_rancher.ips[0], "sslip.io"])}_kubeconfig.yml")
}

resource "ssh_resource" "retrieve_kubeconfig" {
  host = ionoscloud_server.server_rancher_first.primary_ip
  commands = [
    "sed 's/127.0.0.1/${ionoscloud_networkloadbalancer.lb_rancher.ips[0]}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user     = var.image_ssh_user
  password = random_password.sles_image_password.result
}

resource "local_file" "kube_config_yaml" {
  filename        = local.kc_file
  content         = ssh_resource.retrieve_kubeconfig.result
  file_permission = "0600"
}
