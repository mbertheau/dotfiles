#!/usr/bin/env bash
set -euo pipefail

PLATFORM="aarch64-unknown-linux-gnu"
BASE_URL="https://github.com/astral-sh/uv/releases/latest/download"
TARBALL="uv-${PLATFORM}.tar.gz"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

curl -fsSL -o "$tmpdir/$TARBALL" "$BASE_URL/$TARBALL"
curl -fsSL -o "$tmpdir/$TARBALL.sha256" "$BASE_URL/$TARBALL.sha256"

cd "$tmpdir"
sha256sum -c "$TARBALL.sha256"

tar --strip-components=1 -xzf "$TARBALL" -C "$HOME/.local/bin" \
    "uv-${PLATFORM}/uv" "uv-${PLATFORM}/uvx"
