# SPDX-FileCopyrightText: SUSE LLC
#
# SPDX-License-Identifier: Apache-2.0

.PHONY: docs

# Update terraform docs in README.md
docs:
	@echo "Updating Terraform docs..."
	@terraform-docs markdown table . --output-file README.md --indent 3
	@echo "Done!"

release:
	@cz bump
	@git push origin main
	@git push origin --tags
