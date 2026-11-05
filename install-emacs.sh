#!/usr/bin/env bash
set -euo pipefail

# Emacs ignores ~/.config/emacs while ~/.emacs.d exists.
rm -rf ~/.emacs.d
git clone https://github.com/plexus/chemacs2.git ~/.config/emacs

cd ~/src
rm -rf doom-emacs
git clone https://github.com/hlissner/doom-emacs
doom-emacs/bin/doom install --env
emacs --batch -L doom-emacs/.local/straight/repos/nerd-icons.el -l nerd-icons \
    --eval '(nerd-icons-install-fonts t)'
