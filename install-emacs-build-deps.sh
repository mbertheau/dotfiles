#!/usr/bin/env bash
set -euo pipefail

# mailutils recommends postfix, which prompts even with apt --yes.
sudo debconf-set-selections <<EOF
postfix postfix/main_mailer_type select Local only
postfix postfix/mailname string $(hostname --fqdn)
EOF

# libwebkit2gtk-4.1-dev: xwidgets. libgccjit-15-dev: native-comp for the default gcc.
sudo apt install --yes \
    autoconf \
    automake \
    build-essential \
    gawk \
    git \
    libacl1-dev \
    libasound2-dev \
    libcairo2-dev \
    libdbus-1-dev \
    libfreetype-dev \
    libgccjit-15-dev \
    libgif-dev \
    libglib2.0-dev \
    libgmp-dev \
    libgnutls28-dev \
    libgpm-dev \
    libgtk-3-dev \
    libharfbuzz-dev \
    libjpeg-dev \
    liblcms2-dev \
    libm17n-dev \
    libncurses-dev \
    libotf-dev \
    libpango1.0-dev \
    libpng-dev \
    librsvg2-dev \
    libselinux-dev \
    libsqlite3-dev \
    libsystemd-dev \
    libtiff-dev \
    libtree-sitter-dev \
    libwebkit2gtk-4.1-dev \
    libwebp-dev \
    libx11-dev \
    libxcomposite-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxinerama-dev \
    libxml2-dev \
    libxpm-dev \
    libxrandr-dev \
    libxrender-dev \
    mailutils \
    pkg-config \
    texinfo \
    zlib1g-dev
