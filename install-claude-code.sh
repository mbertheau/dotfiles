#!/usr/bin/env bash
set -euo pipefail

# Distilled from https://claude.ai/install.sh

GCS_BUCKET="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"
PLATFORM="linux-arm64"

version=$(curl -fsSL "$GCS_BUCKET/latest")
manifest=$(curl -fsSL "$GCS_BUCKET/$version/manifest.json")
checksum=$(echo "$manifest" | jq -r ".platforms[\"$PLATFORM\"].checksum")

if [[ -z "$checksum" || ! "$checksum" =~ ^[a-f0-9]{64}$ ]]; then
    echo "Platform $PLATFORM not found in manifest" >&2
    exit 1
fi

binary_path=$(mktemp)
trap 'rm -f "$binary_path"' EXIT

curl -fsSL -o "$binary_path" "$GCS_BUCKET/$version/$PLATFORM/claude"

actual=$(sha256sum "$binary_path" | cut -d' ' -f1)
if [[ "$actual" != "$checksum" ]]; then
    echo "Checksum verification failed" >&2
    exit 1
fi

chmod +x "$binary_path"
"$binary_path" install
