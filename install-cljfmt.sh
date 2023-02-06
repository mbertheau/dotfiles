#!/usr/bin/env bash

cd ~
# Need token in ~/.gu/config to get the enterprise edition
src/dotfiles/get-graalvm.sh
export JAVA_HOME=~/graalvm-ee-java17-22.3.1
export PATH=$JAVA_HOME/bin:$PATH
cd src/cljfmt/cljfmt
lein native-image
cp target/cljfmt ~/.local/bin/
