#!/usr/bin/env bash
set -euo pipefail

wget -qO- https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /usr/share/keyrings/microsoft.gpg >/dev/null

echo "deb [arch=arm64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |
    sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null

sudo apt update
sudo apt install --yes code
