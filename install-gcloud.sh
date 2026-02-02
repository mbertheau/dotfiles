#!/usr/bin/env bash

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg |
    sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |
    sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

sudo apt update
sudo apt install -y google-cloud-cli python3-grpcio

# gcloud runs python with -S (no site-packages) by default, but grpc is in site-packages
echo 'export CLOUDSDK_PYTHON_SITEPACKAGES=1' >>~/.bashrc
