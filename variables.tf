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
  default     = null
}

variable "rke2_config" {
  type        = string
  description = "Additional RKE2 configuration to add to the config.yaml file"
  default     = null
}
