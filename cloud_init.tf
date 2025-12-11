# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

data "cloudinit_config" "server_rancher_first" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "rke2.sh"
    content_type = "text/x-shellscript"

    content = module.rke2_first.rke2_user_data
  }

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = <<-EOT
      #cloud-config
      hostname: rancher0
      create_hostname_file: true
      prefer_fqdn_over_hostname: false

      runcmd:
      - SUSEConnect -r ${var.scc_registration_code} -e ${var.scc_registration_email}
      - zypper ref && zypper --non-interactive in iptables
      - zypper --non-interactive dup
    EOT
  }
}


data "cloudinit_config" "server_rancher_additional" {
  count = 2

  gzip          = false
  base64_encode = true

  part {
    filename     = "rke2.sh"
    content_type = "text/x-shellscript"

    content = module.rke2_additional.rke2_user_data
  }

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = <<-EOT
      #cloud-config
      hostname: rancher${count.index + 1}
      create_hostname_file: true
      prefer_fqdn_over_hostname: false

      runcmd:
      - SUSEConnect -r ${var.scc_registration_code} -e ${var.scc_registration_email}
      - zypper ref && zypper --non-interactive in iptables
      - zypper --non-interactive dup
    EOT
  }
}
