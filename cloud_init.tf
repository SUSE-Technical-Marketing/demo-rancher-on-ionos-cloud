# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

data "cloudinit_config" "server_rancher_first" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = <<-EOT
      #cloud-config
      hostname: rancher0
      create_hostname_file: true
      prefer_fqdn_over_hostname: false

      write_files:
        - path: /opt/rke2-install.sh
          permissions: '0755'
          encoding: b64
          content: ${base64encode(module.rke2_first.rke2_user_data)}

        - path: /etc/systemd/system/rke2-installer.service
          permissions: '0644'
          content: |
            [Unit]
            Description=Install RKE2 (10 Retries)
            After=network-online.target
            Wants=network-online.target

            # Allow 10 starts within a 10-minute window.
            # If we hit 10 failures, stop trying.
            StartLimitBurst=10
            StartLimitIntervalSec=600

            [Service]
            Type=oneshot
            ExecStart=/opt/rke2-install.sh

            # If script fails, wait 30 seconds before restart
            Restart=on-failure
            RestartSec=30s

            [Install]
            WantedBy=multi-user.target

      runcmd:
      - SUSEConnect -r ${var.scc_registration_code} -e ${var.scc_registration_email}
      - zypper ref && zypper --non-interactive in iptables
      - zypper --non-interactive dup
      - systemctl daemon-reload
      - systemctl enable --now rke2-installer.service
    EOT
  }
}

data "cloudinit_config" "server_rancher_additional" {
  count = 2

  gzip          = false
  base64_encode = true

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = <<-EOT
      #cloud-config
      hostname: rancher${count.index + 1}
      create_hostname_file: true
      prefer_fqdn_over_hostname: false

      write_files:
        - path: /opt/rke2-install.sh
          permissions: '0755'
          encoding: b64
          content: ${base64encode(module.rke2_additional.rke2_user_data)}

        - path: /etc/systemd/system/rke2-installer.service
          permissions: '0644'
          content: |
            [Unit]
            Description=Install RKE2 (10 Retries)
            After=network-online.target
            Wants=network-online.target

            # Allow 10 starts within a 10-minute window.
            # If we hit 10 failures, stop trying.
            StartLimitBurst=10
            StartLimitIntervalSec=600

            [Service]
            Type=oneshot
            ExecStart=/opt/rke2-install.sh

            # If script fails, wait 30 seconds before restart
            Restart=on-failure
            RestartSec=30s

            [Install]
            WantedBy=multi-user.target

      runcmd:
      - SUSEConnect -r ${var.scc_registration_code} -e ${var.scc_registration_email}
      - zypper ref && zypper --non-interactive in iptables
      - zypper --non-interactive dup
      - systemctl daemon-reload
      - systemctl enable --now rke2-installer.service
    EOT
  }
}
