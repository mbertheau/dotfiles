#!/usr/bin/env bash
set -euo pipefail

sudo snap install bitwarden

# Required for Bitwarden to store credentials in the system keyring.
# https://snapcraft.io/bitwarden
sudo snap connect bitwarden:password-manager-service
