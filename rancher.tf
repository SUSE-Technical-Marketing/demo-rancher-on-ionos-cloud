# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

locals {
  rancher_hostname = join(".", ["rancher", ionoscloud_networkloadbalancer.lb_rancher.ips[0], "sslip.io"])
  first_server_ip  = ionoscloud_ipblock.ip_server_rancher_first.ips[0]
  kc_file          = pathexpand("${path.cwd}/${local.first_server_ip}_kubeconfig.yml")
}

resource "ssh_resource" "retrieve_kubeconfig" {
  depends_on = [ionoscloud_server.server_rancher_first]
  host       = local.first_server_ip
  commands = [
    "sed 's/127.0.0.1/${local.first_server_ip}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user     = var.image_ssh_user
  password = random_password.sles_image_password.result
}

resource "local_file" "kube_config_yaml" {
  filename        = local.kc_file
  content         = ssh_resource.retrieve_kubeconfig.result
  file_permission = "0600"
}

module "rancher_install" {
  source                                = "./tf-rancher-up/modules/rancher"
  dependency                            = [ionoscloud_server.server_rancher_first, ionoscloud_server.server_rancher_additional]
  kubeconfig_file                       = local_file.kube_config_yaml.filename
  rancher_hostname                      = local.rancher_hostname
  rancher_replicas                      = var.rancher_replicas
  rancher_bootstrap_password            = var.rancher_bootstrap_password
  rancher_password                      = var.rancher_password
  rancher_version                       = var.rancher_version
  rancher_helm_repository               = var.rancher_helm_repository
  rancher_helm_repository_username      = var.rancher_helm_repository_username
  rancher_helm_repository_password      = var.rancher_helm_repository_password
  rancher_helm_upgrade_install          = var.rancher_helm_upgrade_install
  rancher_helm_atomic                   = var.rancher_helm_atomic
  cert_manager_helm_repository          = var.cert_manager_helm_repository
  cert_manager_helm_repository_username = var.cert_manager_helm_repository_username
  cert_manager_helm_repository_password = var.cert_manager_helm_repository_password
  cert_manager_helm_upgrade_install     = var.cert_manager_helm_upgrade_install
  cert_manager_helm_atomic              = var.cert_manager_helm_atomic
  registry_password                     = var.registry_password
  registry_username                     = var.registry_username
  tls_source                            = var.tls_source
  tls_crt_path                          = var.tls_crt_path
  tls_key_path                          = var.tls_key_path
  cacerts_path                          = var.cacerts_path
  helm_timeout                          = var.helm_timeout
  rancher_additional_helm_values = distinct(flatten([
    ["letsEncrypt.environment: ${var.letsencrypt_environment}"],
    var.rancher_additional_helm_values
  ]))
  cert_manager_version = var.cert_manager_version
}
