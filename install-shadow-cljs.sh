#!/usr/bin/env bash

cd ~
mkdir -p ~/.shadow-cljs
ln -s ../src/dotfiles/.shadow-cljs/config.edn ~/.shadow-cljs/

cd ~/.shadow-cljs/

# adapted from https://letsencrypt.org/docs/certificates-for-localhost/
openssl req -x509 -out localhost.crt -keyout localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

# adapted from https://stackoverflow.com/questions/57453154/how-to-add-crt-file-to-keystore-and-trust-store
keytool -import -alias testalias -file localhost.crt -keystore shadow-cljs.jks -storepass shadow-cljs
