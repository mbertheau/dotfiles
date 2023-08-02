#!/usr/bin/env bash

cd ~/src
rm -rf spacemacs
git clone git@github.com:mbertheau/spacemacs.git
cd spacemacs
git remote add -f upstream git@github.com:syl20bnr/spacemacs.git
git checkout upstream/develop
