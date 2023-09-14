#!/usr/bin/env bash

cd ~/Downloads
wget https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64
sudo dpgk -i code_1*.deb
