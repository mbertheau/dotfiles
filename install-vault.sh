#!/usr/bin/env bash
set -euo pipefail

wget -nv -O- https://apt.releases.hashicorp.com/gpg |
    gpg --dearmor |
    sudo tee /etc/apt/keyrings/hashicorp-archive-keyring.gpg >/dev/null

echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" |
    sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install --yes vault
