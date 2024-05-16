#!/usr/bin/env bash

cd ~
wget -q https://download.clojure.org/install/linux-install-1.11.1.1224.sh
chmod +x linux-install-1.11.1.1224.sh
sudo ./linux-install-1.11.1.1224.sh
rm linux-install-1.11.1.1224.sh
