#!/usr/bin/env bash
set -euo pipefail

wget -qO - https://archive.regolith-desktop.com/regolith.key |
    gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg >/dev/null

echo deb "[arch=arm64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://archive.regolith-desktop.com/ubuntu/unstable resolute main" |
    sudo tee /etc/apt/sources.list.d/regolith.list

sudo apt update

sudo apt install --yes \
    i3xrocks-cpu-usage \
    i3xrocks-keyboard-layout \
    i3xrocks-key-indicator \
    i3xrocks-net-traffic \
    i3xrocks-nm-vpn \
    i3xrocks-openvpn \
    i3xrocks-time \
    regolith-desktop \
    regolith-session-sway

cd
mkdir -p ~/.config/regolith3
ln -s ../../src/dotfiles/.config/regolith3/Xresources ~/.config/regolith3/Xresources
mkdir -p ~/.config/i3status-rust
ln -s ../../src/dotfiles/.config/i3status-rust/config.toml ~/.config/i3status-rust/config.toml

# TODO: /etc/regolith/i3/config mit workspace_auto_back_and_forth
# https://github.com/regolith-linux/regolith-i3-gaps-config/pull/20
