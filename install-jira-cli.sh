#!/usr/bin/env bash
set -euo pipefail

# Atlassian CLI (acli) - https://developer.atlassian.com/cloud/acli/guides/install-linux/

sudo apt-get install -y wget gnupg2

sudo mkdir -p -m 755 /etc/apt/keyrings
wget -nv -O- https://acli.atlassian.com/gpg/public-key.asc |
    sudo gpg --dearmor -o /etc/apt/keyrings/acli-archive-keyring.gpg
sudo chmod go+r /etc/apt/keyrings/acli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/acli-archive-keyring.gpg] https://acli.atlassian.com/linux/deb stable main" |
    sudo tee /etc/apt/sources.list.d/acli.list >/dev/null

sudo apt update
sudo apt install -y acli
