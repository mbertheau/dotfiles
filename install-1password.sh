#!/usr/bin/env bash

curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] \
https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
    sudo tee /etc/apt/sources.list.d/1password.list

sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22

curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

sudo apt update
sudo apt install 1password-cli

cd ~/Downloads
curl -sSO https://downloads.1password.com/linux/tar/stable/aarch64/1password-latest.tar.gz
tar -xf 1password-latest.tar.gz
sudo mkdir -p /opt/1Password && sudo mv 1password-*/* /opt/1Password

# Verified this version of after-install.sh; refuse to run a different one.
EXPECTED_HASH="84fbc67fbe089f09199c5195116f802e5f460498929e96ce2deb9753e5cd4a5d"
ACTUAL_HASH=$(sha256sum /opt/1Password/after-install.sh | cut -d' ' -f1)
if [[ "$ACTUAL_HASH" != "$EXPECTED_HASH" ]]; then
    echo "after-install.sh checksum mismatch." >&2
    echo "Expected: $EXPECTED_HASH" >&2
    echo "Got:      $ACTUAL_HASH" >&2
    echo "Review the new version and update the hash in this script." >&2
    exit 1
fi
sudo /opt/1Password/after-install.sh

echo 'Now, enable "Unlock using system authentication" and "Integrate with 1Password CLI" in the 1Password settings.'
