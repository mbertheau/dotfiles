#!/usr/bin/env bash
set -euo pipefail

KEY_FINGERPRINT="3FEF9748469ADBE15DA7CA80AC2D62742012EA22"
KEYRING="/etc/apt/keyrings/1password-archive-keyring.gpg"

key=$(wget -nv -O- https://downloads.1password.com/linux/keys/1password.asc)
fingerprint=$(gpg --show-keys --with-colons <<<"$key" | awk -F: '$1 == "fpr" { print $10; exit }')
if [[ "$fingerprint" != "$KEY_FINGERPRINT" ]]; then
    echo "1Password key fingerprint mismatch." >&2
    echo "Expected: $KEY_FINGERPRINT" >&2
    echo "Got:      $fingerprint" >&2
    exit 1
fi
gpg --dearmor <<<"$key" | sudo tee "$KEYRING" >/dev/null

echo "deb [arch=arm64 signed-by=$KEYRING] \
https://downloads.1password.com/linux/debian/arm64 stable main" |
    sudo tee /etc/apt/sources.list.d/1password.list

sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
wget -nv -O- https://downloads.1password.com/linux/debian/debsig/1password.pol |
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
sudo cp "$KEYRING" /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

sudo apt update
sudo apt install --yes 1password-cli

cd ~/Downloads
wget -nv https://downloads.1password.com/linux/tar/stable/aarch64/1password-latest.tar.gz
wget -nv https://downloads.1password.com/linux/tar/stable/aarch64/1password-latest.tar.gz.sig
# after-install.sh runs as root, so the tarball it comes in must be signed by 1Password.
gpgv --keyring "$KEYRING" 1password-latest.tar.gz.sig 1password-latest.tar.gz
tar -xf 1password-latest.tar.gz
sudo mkdir -p /opt/1Password && sudo mv 1password-*/* /opt/1Password
sudo /opt/1Password/after-install.sh

echo 'Now, enable "Unlock using system authentication" and "Integrate with 1Password CLI" in the 1Password settings.'
