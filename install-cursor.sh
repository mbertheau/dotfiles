#!/usr/bin/env bash
set -euo pipefail

# This endpoint tracks the latest golden 3.18.x build, so its contents change on
# every patch release. Verified this build; refuse to install a different one.
CURSOR_DEB_URL="https://api2.cursor.sh/updates/download/golden/linux-arm64-deb/cursor/3.18"
EXPECTED_HASH="e4e7e68468e19ad1f3b627aa3a5ab67ec01a6326da1e293aff7b5f5fc9b7c9c1"

deb_path=$(mktemp --suffix=.deb)
trap 'rm -f "$deb_path"' EXIT

curl -fSL -o "$deb_path" "$CURSOR_DEB_URL"

ACTUAL_HASH=$(sha256sum "$deb_path" | cut -d' ' -f1)
if [[ "$ACTUAL_HASH" != "$EXPECTED_HASH" ]]; then
    echo "Cursor .deb checksum mismatch." >&2
    echo "Expected: $EXPECTED_HASH" >&2
    echo "Got:      $ACTUAL_HASH" >&2
    echo "Review the new version and update the hash in this script." >&2
    exit 1
fi

# The .deb's postinst asks on a TTY whether to add Cursor's apt repo.
sudo debconf-set-selections <<EOF
cursor cursor/add-cursor-repo boolean true
EOF

sudo apt install --yes "$deb_path"
