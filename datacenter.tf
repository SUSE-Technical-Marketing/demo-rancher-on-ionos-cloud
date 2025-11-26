# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

resource "ionoscloud_datacenter" "vdc" {
  name                = var.datacenter_name
  location            = var.datacenter_location
  description         = var.datacenter_description
  sec_auth_protection = false
}
