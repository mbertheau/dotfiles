#!/usr/bin/env bash

wget https://github.com/dandavison/delta/releases/download/0.9.2/git-delta_0.15.1_arm64.deb
sudo dpkg -i git-delta_0.15.1_arm64.deb
rm git-delta_0.15.1_arm64.deb
