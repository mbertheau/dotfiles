#!/usr/bin/env bash

curl -fsSL "https://packages.buildkite.com/buildkite/cli-deb/gpgkey" |
    sudo gpg --dearmor -o /etc/apt/keyrings/buildkite_cli-deb-archive-keyring.gpg

echo -e "deb [signed-by=/etc/apt/keyrings/buildkite_cli-deb-archive-keyring.gpg] https://packages.buildkite.com/buildkite/cli-deb/any/ any main\ndeb-src [signed-by=/etc/apt/keyrings/buildkite_cli-deb-archive-keyring.gpg] https://packages.buildkite.com/buildkite/cli-deb/any/ any main" |
    sudo tee /etc/apt/sources.list.d/buildkite-buildkite-cli-deb.list

sudo apt update
sudo apt install -y bk

