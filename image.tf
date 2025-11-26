# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

data "ionoscloud_image" "sles" {
  type        = "HDD"
  cloud_init  = "V1"
  image_alias = var.image_sles
  location    = var.datacenter_location
}

resource "random_password" "sles_image_password" {
  length  = 16
  special = false
}
