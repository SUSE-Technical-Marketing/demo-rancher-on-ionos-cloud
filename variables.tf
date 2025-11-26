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
  default     = "de/fra" # Available locations: de/fra, us/las, us/ewr, de/txl, gb/lhr, gb/bhx, es/vit, fr/par, us/mci, de/fra/2
  nullable    = false
}

variable "datacenter_description" {
  type        = string
  description = "Virtual Data Center description"
  default     = "SUSE Rancher Prime on IONOS Cloud Demo"
  nullable    = false
}
