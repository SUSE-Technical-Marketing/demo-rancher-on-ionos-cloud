# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

terraform {
  required_version = ">= 1.10"

  required_providers {
    ionoscloud = {
      source  = "ionos-cloud/ionoscloud"
      version = "6.7.20"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
