WORK_OR_HOME=$1

sudo apt purge --yes nano

# prepare apt to install regolith
wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-ubuntu-jammy-amd64 jammy main" | \
sudo tee /etc/apt/sources.list.d/regolith.list


# prepare apt to install gh
wget -qO - https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt update

# clang: weiss nicht mehr
# fd-find: doom emacs
# gettext: ./manage.py compilemessages
# neovim: sensible editor for the terminal
# net-tools: for netstat
# pandoc: seacemacs markdown
# watchman: react-native
# libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386: Android Studio
# python3-dev: installing / compiling psycopg
# openvpn-systemd-resolved: work vpn DNS
# pspg: best tabular data pager ever
# curl: in general good to have, but also leiningen uses it to install itself
# libbz2-dev libreadline-dev libssl-dev libsqlite3-dev: python 3.7 build
# zstd: doom emacs persistent undo history compression/speedup
# editorconfig: editorconfig module in doom emacs
# suckless-tools:d dmenu, for passmenu
# rlwrap: Clojure CLI tools
# tk-dev: for pyenv to compile Python with tk support for matplotlib UI
# liblzma-dev: for pyenv to compile Python and not remark that it's without lzma support
# libsdl2-dev: for building python ai stuff with python 3.11
# libsdl2-image-dev: same
# libsdl2-ttf-dev: same
# libjpeg8-dev: same
# libportmidi-dev: same

sudo apt install --yes \
     chromium-browser \
     clang \
     colordiff \
     curl \
     editorconfig \
     emacs \
     fd-find \
     gettext \
     gh \
     i3xrocks-cpu-usage \
     i3xrocks-keyboard-layout \
     i3xrocks-key-indicator \
     i3xrocks-net-traffic \
     i3xrocks-nm-vpn \
     i3xrocks-openvpn \
     i3xrocks-time \
     leiningen \
     libbz2-dev \
     libjpeg8-dev \
     liblzma-dev \
     libreadline-dev \
     libportmidi-dev \
     libpq-dev \
     libsdl2-dev \
     libsdl2-image-dev \
     libsdl2-ttf-dev \
     libssl-dev \
     libsqlite3-dev \
     neovim \
     net-tools \
     openjdk-11-jdk \
     openvpn-systemd-resolved \
     pandoc \
     pass \
     poedit \
     postgresql-14-postgis-3 \
     pspg \
     python3-dev \
     python3-venv \
     regolith-desktop \
     rlwrap \
     ripgrep \
     suckless-tools \
     tk-dev \
     watchman \
     libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

sudo apt upgrade --yes

# clean up
sudo apt --yes autoremove

sudo snap install shellcheck docker

wget https://github.com/dandavison/delta/releases/download/0.9.2/git-delta_0.9.2_amd64.deb
sudo dpkg -i git-delta_0.9.2_amd64.deb
rm git-delta_0.9.2_amd64.deb

# install config files

cd
ln -s src/dotfiles/{.emacs-profiles.el,.emacs-profile,.spacemacs,.gitconfig,.bashrc_local} ~/

mkdir -p ~/.config/regolith2
ln -s ../../src/dotfiles/.config/regolith2/Xresources ~/.config/regolith2/Xresources

mkdir -p ~/.local/bin
if [[ $WORK_OR_HOME == "work" ]]; then
    ln -s ../../src/dotfiles/.local/bin/{flowdock,teams,outlook} ~/.local/bin/
fi

ln -s ../../src/dotfiles/.local/bin/{clojurians,doomacs,spacemacs} ~/.local/bin/

cp /usr/share/doc/pass/examples/dmenu/passmenu ~/.local/bin

mkdir -p ~/.shadow-cljs
ln -s ../src/dotfiles/.shadow-cljs/config.edn ~/.shadow-cljs/

# TODO: /etc/regolith/i3/config mit workspace_auto_back_and_forth
# https://github.com/regolith-linux/regolith-i3-gaps-config/pull/20

# .profile does this at login, but only if ~/.local/bin exists, which it didn't at login
export PATH="$HOME/.local/bin:$PATH"

echo source ~/.bashrc_local >> ~/.bashrc
source ~/.bashrc_local

# disable file indexing
# https://www.linuxuprising.com/2019/07/how-to-completely-disable-tracker.html
systemctl --user mask \
    tracker-extract-3.service \
    tracker-miner-fs-3.service \
    tracker-writeback-3.service \
    tracker-xdg-portal-3.service \
    tracker-miner-fs-control-3.service

# vpn
if [[ $WORK_OR_HOME == "work" ]]; then
    cd ~/Documents/m.bertheau_workstation
    sudo cp *.{crt,key,conf} /etc/openvpn/
    sudo systemctl enable openvpn@machtfit.service
    sudo systemctl start openvpn@machtfit.service
fi

# install other software

cd
git clone https://github.com/plexus/chemacs2.git ~/.config/emacs

cd ~/src
rm -rf spacemacs
git clone git@github.com:mbertheau/spacemacs.git
cd spacemacs
git remote add -f upstream git@github.com:syl20bnr/spacemacs.git
git checkout upstream/develop


~/src/dotfiles/install-doom-emacs.sh

cd
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
source ~/.nvm/nvm.sh
nvm install --lts=hydrogen
nvm alias default 18

# Android Studio
# cd
# wget -q wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/4.1.3.0/android-studio-ide-201.7199119-linux.tar.gz
# tar xf android-studio-ide-*-linux.tar.gz
# rm android-studio-ide-*-linux.tar.gz
# cat >> ~/.bashrc <<EOF
# export ANDROID_HOME=$HOME/Android/Sdk
# export PATH=$PATH:$ANDROID_HOME/emulator
# export PATH=$PATH:$ANDROID_HOME/tools
# export PATH=$PATH:$ANDROID_HOME/tools/bin
# export PATH=$PATH:$ANDROID_HOME/platform-tools
# EOF
# allow access to my Android Phone
# echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2a70", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android-usb.rules
# echo "Set up Android Studio for React Native according to https://reactnative.dev/docs/environment-setup"

# pyenv + pyenv-virtualenv
cd

curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# set up machtfit dev environment
if [[ $WORK_OR_HOME == "work" ]]; then
    pyenv install 3.7.12

    sudo -u postgres createuser --superuser markus
fi

# sqlfmt
cd ~/.local/bin/
wget -qO- https://api.github.com/repos/mjibson/sqlfmt/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d\" -f4 | wget -q -i - -O- | tar xz

# Clojure CLI
cd ~
wget -q https://download.clojure.org/install/linux-install-1.11.1.1200.sh
chmod +x linux-install-1.11.1.1200.sh
sudo ./linux-install-1.11.1.1200.sh
rm linux-install-1.11.1.1200.sh

# leiningen
cd ~/.local/bin
wget -qOlein https://raw.github.com/technomancy/leiningen/stable/bin/lein
chmod +x lein
