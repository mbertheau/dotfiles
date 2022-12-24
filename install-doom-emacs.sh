#!/usr/bin/env bash

mkdir -p ~/.doom.d/themes
cd ~/.doom.d/themes
wget https://raw.githubusercontent.com/the-frey/cyberpunk-2019/master/cyberpunk-2019-theme.el

cd ~/src
rm -rf doom-emacs
git clone https://github.com/hlissner/doom-emacs
doom-emacs/bin/doom install
