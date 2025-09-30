#!/usr/bin/env bash

sudo apt install --yes graphviz
mkdir -p ~/schemaspy
cd ~/schemaspy
wget https://github.com/schemaspy/schemaspy/releases/download/v6.2.4/schemaspy-6.2.4.jar
wget https://jdbc.postgresql.org/download/postgresql-42.6.0.jar
