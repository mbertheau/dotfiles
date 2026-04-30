#!/usr/bin/env bash
set -euo pipefail

wget -nv -O- "https://packages.buildkite.com/buildkite/cli-deb/gpgkey" |
    sudo gpg --dearmor -o /etc/apt/keyrings/buildkite_cli-deb-archive-keyring.gpg

echo -e "deb [arch=arm64 signed-by=/etc/apt/keyrings/buildkite_cli-deb-archive-keyring.gpg] https://packages.buildkite.com/buildkite/cli-deb/any/ any main\ndeb-src [arch=arm64 signed-by=/etc/apt/keyrings/buildkite_cli-deb-archive-keyring.gpg] https://packages.buildkite.com/buildkite/cli-deb/any/ any main" |
    sudo tee /etc/apt/sources.list.d/buildkite-buildkite-cli-deb.list

sudo apt update
sudo apt install --yes bk
