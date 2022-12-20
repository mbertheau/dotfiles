#!/usr/bin/env bash

cd ~/src
rm -rf doom-emacs
git clone https://github.com/hlissner/doom-emacs
doom-emacs/bin/doom install
