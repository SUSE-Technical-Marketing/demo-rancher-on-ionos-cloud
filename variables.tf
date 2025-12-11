# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

variable "datacenter_name" {
  type        = string
  description = "Name of the Virtual Data Center"
  default     = "demo-rancher-on-ionos-cloud"
  nullable    = false
}

variable "datacenter_location" {
  type        = string
  description = "Location / Region of the Virtual Data Center"
  default     = "de/fra" # Locations with SLES 15 images: de/fra, de/txl, de/fra/2
  nullable    = false
}

variable "datacenter_description" {
  type        = string
  description = "Virtual Data Center description"
  default     = "SUSE Rancher Prime on IONOS Cloud Demo"
  nullable    = false
}

variable "lan_public_name" {
  type        = string
  description = "Name of the public network"
  default     = "public-network"
  nullable    = false
}

variable "lan_private_name" {
  type        = string
  description = "Name of the private network"
  default     = "private-network"
  nullable    = false
}

variable "image_sles" {
  type        = string
  description = "Name of the SLES image to use for virtual machines"
  default     = "sles:15sp7"
  nullable    = false
}

variable "image_ssh_user" {
  type        = string
  description = "Username for SSH access"
  default     = "root"
  nullable    = false
}

variable "server_ssh_keys" {
  type        = list(any)
  description = "List of SSH public keys used when a virtual machine is deployed"
  default     = []
}

variable "scc_registration_code" {
  type        = string
  description = "SLES Registration Code"
  nullable    = false
}

variable "scc_registration_email" {
  type        = string
  description = "SLES Registration Email"
  nullable    = false
}

variable "rke2_version" {
  type        = string
  description = "Kubernetes version to use for the RKE2 cluster"
  default     = "v1.34.2+rke2r1"
  nullable    = false
}

variable "rke2_config" {
  type        = string
  description = "Additional RKE2 configuration to add to the config.yaml file"
  default     = null
}

variable "server_rancher_cpu_cores" {
  type        = string
  description = "CPU cores assigned to Rancher Manager servers"
  default     = "4"
}

variable "server_rancher_ram" {
  type        = string
  description = "RAM assigned to Rancher Manager servers"
  default     = "16384"
}

variable "server_rancher_disk_size" {
  type        = string
  description = "Disk size assigned to Rancher Manager servers"
  default     = "600"
}

variable "rancher_bootstrap_password" {
  description = "Password to use when bootstrapping Rancher (min 12 characters)"
  default     = null
  type        = string

  validation {
    condition     = var.rancher_bootstrap_password == null ? true : length(var.rancher_bootstrap_password) >= 12
    error_message = "The password provided for Rancher (rancher_bootstrap_password) must be at least 12 characters"
  }
}

variable "rancher_password" {
  description = "Password for the Rancher admin account (min 12 characters)"
  default     = null
  type        = string

  validation {
    condition     = var.rancher_password == null ? true : length(var.rancher_password) >= 12
    error_message = "The password provided for Rancher (rancher_password) must be at least 12 characters"
  }
}

variable "rancher_version" {
  description = "Rancher version to install"
  default     = "2.13.0"
  type        = string
  nullable    = false
}

variable "rancher_replicas" {
  description = "Value for replicas when installing the Rancher helm chart"
  default     = 3
  type        = number
}

variable "rancher_helm_repository" {
  description = "Helm repository for Rancher chart"
  default     = null
  type        = string
}

variable "rancher_helm_repository_username" {
  description = "Private Rancher helm repository username"
  default     = null
  type        = string
}

variable "rancher_helm_repository_password" {
  description = "Private Rancher helm repository password"
  default     = null
  type        = string
}

variable "cert_manager_helm_repository" {
  description = "Helm repository for Cert Manager chart"
  default     = null
  type        = string
}

variable "rancher_helm_atomic" {
  description = "Purge cert-manager chart on fail"
  default     = false
  type        = bool
}

variable "rancher_helm_upgrade_install" {
  description = "Install the release even if a release not controlled by the provider is present. Equivalent to running 'helm upgrade --install'"
  default     = true
  type        = bool
}

variable "cert_manager_helm_repository_username" {
  description = "Private Cert Manager helm repository username"
  default     = null
  type        = string
}

variable "cert_manager_helm_repository_password" {
  description = "Private Cert Manager helm repository password"
  default     = null
  type        = string
}

variable "cert_manager_helm_atomic" {
  description = "Purge cert-manager chart on fail"
  default     = false
  type        = bool
}

variable "cert_manager_helm_upgrade_install" {
  description = "Install the release even if a release not controlled by the provider is present. Equivalent to running 'helm upgrade --install'"
  default     = true
  type        = bool
}

variable "registry_username" {
  description = "Private container image registry username"
  default     = null
  type        = string
}

variable "registry_password" {
  description = "Private container image registry password"
  default     = null
  type        = string
}

variable "tls_source" {
  description = "Value for ingress.tls.source when installing the Rancher helm chart. Options: rancher, letsEncrypt, secret"
  default     = "letsencrypt"
  type        = string
}

variable "letsencrypt_environment" {
  description = "Let's Encrypt environment to use staging or production"
  default     = "production"
  type        = string
}

variable "cacerts_path" {
  default     = null
  description = "Private CA certificate to use for Rancher UI/API connectivity"
  type        = string
}

variable "tls_crt_path" {
  description = "TLS certificate to use for Rancher UI/API connectivity"
  default     = null
  type        = string
}

variable "tls_key_path" {
  description = "TLS key to use for Rancher UI/API connectivity"
  default     = null
  type        = string
}

variable "cert_manager_version" {
  description = "Version of cert-manager to install"
  default     = "1.19.2"
  type        = string
  nullable    = false
}

variable "rancher_additional_helm_values" {
  description = "Helm options to provide to the Rancher helm chart"
  default     = []
  type        = list(string)
}

variable "helm_timeout" {
  description = "Specify the timeout value in seconds for helm operation(s)"
  default     = 600
  type        = number
}
