#!/usr/bin/env bash
set -euo pipefail

# This endpoint tracks the latest golden 3.12.x build, so its contents change on
# every patch release. Verified this build; refuse to install a different one.
CURSOR_DEB_URL="https://api2.cursor.sh/updates/download/golden/linux-arm64-deb/cursor/3.12"
EXPECTED_HASH="0306ae2a6417d4aa83d456606348db1454ac9a4dcfda15721febff442bce7b95"

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

sudo apt install --yes "$deb_path"
