#!/usr/bin/env bash
set -euo pipefail

ensure_symlink() {
    local dest=$1
    local target=$2
    local expected
    expected=$(readlink -f "$target")

    if [[ ! -d "$expected" ]]; then
        echo "$target is not a directory" >&2
        exit 1
    fi

    if [[ -L "$dest" ]]; then
        local actual
        actual=$(readlink -f "$dest" || true)
        if [[ "$actual" == "$expected" ]]; then
            return 0
        fi
        echo "$dest exists and is not a symlink to $expected" >&2
        exit 1
    fi

    if [[ -e "$dest" ]]; then
        echo "$dest exists and is not a symlink to $expected" >&2
        exit 1
    fi

    ln -s "$expected" "$dest"
}

mkdir -p "$HOME/.cursor"
ensure_symlink "$HOME/.cursor/rules" "$HOME/src/dotfiles/rules"
ensure_symlink "$HOME/.cursor/skills" "$HOME/src/dotfiles/skills"

mkdir -p "$HOME/.cursor/plugins/local"
if [[ ! -e "$HOME/.cursor/plugins/local/mstack" ]]; then
    gh repo clone mbertheau/mstack "$HOME/.cursor/plugins/local/mstack"
fi
