#!/usr/bin/env bash
set -euo pipefail

# Distilled from https://cursor.com/install
CURSOR_VERSION=$(curl -fsS https://cursor.com/install | grep -oP '(?<=versions/)\d{4}\.\d{2}\.\d{2}-[a-f0-9]+' | head -1)
if [[ -z "$CURSOR_VERSION" ]]; then
    echo "Failed to detect Cursor version from https://cursor.com/install"
    exit 1
fi
CURSOR_DIR="$HOME/.local/share/cursor-agent/versions/$CURSOR_VERSION"

mkdir -p "$CURSOR_DIR"
curl -fSL "https://downloads.cursor.com/lab/$CURSOR_VERSION/linux/arm64/agent-cli-package.tar.gz" |
    tar --strip-components=1 -xzf - -C "$CURSOR_DIR"

ln -sf "$CURSOR_DIR/cursor-agent" ~/.local/bin/agent
ln -sf "$CURSOR_DIR/cursor-agent" ~/.local/bin/cursor-agent
