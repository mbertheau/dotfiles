#!/usr/bin/env bash
#https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64

cd ~/Downloads
wget --trust-server-names https://code.visualstudio.com/sha/download?build=stable\&os=linux-deb-arm64
sudo dpkg -i code_1*.deb
