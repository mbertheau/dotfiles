#!/usr/bin/env bash
set -euo pipefail

KEY_URL="https://downloads.cursor.com/keys/anysphere.asc"
KEY_FINGERPRINT="380FF4BCDC34A4BD92A3565342A1772E62E492D6"
KEYRING="/usr/share/keyrings/anysphere.gpg"

key=$(wget -qO- "$KEY_URL")
fingerprint=$(gpg --show-keys --with-colons <<<"$key" | awk -F: '$1 == "fpr" { print $10; exit }')
if [[ "$fingerprint" != "$KEY_FINGERPRINT" ]]; then
    echo "Cursor apt key fingerprint mismatch." >&2
    echo "Expected: $KEY_FINGERPRINT" >&2
    echo "Got:      $fingerprint" >&2
    exit 1
fi
gpg --dearmor <<<"$key" | sudo tee "$KEYRING" >/dev/null

# Same file and content the package's postinst writes, so it doesn't add a second entry.
sudo tee /etc/apt/sources.list.d/cursor.sources >/dev/null <<EOF
### THIS FILE IS AUTOMATICALLY CONFIGURED ###
# You may comment out this entry, but any other modifications may be lost.
Types: deb
URIs: https://downloads.cursor.com/aptrepo
Suites: stable
Components: main
Architectures: amd64,arm64
Signed-By: $KEYRING
EOF

# The postinst asks on a TTY whether to add Cursor's apt repo.
sudo debconf-set-selections <<EOF
cursor cursor/add-cursor-repo boolean true
EOF

sudo apt update
sudo apt install --yes cursor
