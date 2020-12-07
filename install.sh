sudo apt purge --yes nano

# install regolith

sudo add-apt-repository --yes ppa:regolith-linux/release

# clang: weiss nicht mehr
# fd-find: doom emacs
# gettext: ./manage.py compilemessages
# neovim: sensible editor for the terminal
# net-tools: for netstat
# pandoc: seacemacs markdown
# watchman: react-native
# libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386: Android Studio
# python3-dev: installing / compiling psycopg

sudo apt install --yes \
     chromium-browser \
     clang \
     colordiff \
     emacs \
     fd-find \
     gettext \
     git \
     i3xrocks-cpu-usage \
     i3xrocks-keyboard-layout \
     i3xrocks-key-indicator \
     i3xrocks-net-traffic \
     i3xrocks-nm-vpn \
     i3xrocks-openvpn \
     i3xrocks-time \
     leiningen \
     libpq-dev \
     neovim \
     net-tools \
     openjdk-8-jdk \
     pandoc \
     pass \
     postgresql-12-postgis-3 \
     python3-dev \
     python3-venv \
     regolith-desktop \
     ripgrep \
     tar \
     watchman \
     libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

sudo snap install --classic hub

# clean up
sudo apt --yes autoremove

# install config files

cd
ln -s src/dotfiles/{.emacs-profiles.el,.emacs-profile,.spacemacs,.gitconfig,.bashrc_local} ~/
mkdir -p ~/.config/regolith
ln -s ~/src/dotfiles/.config/regolith/Xresources ~/.config/regolith/Xresources

# TODO: /etc/regolith/i3/config mit workspace_auto_back_and_forth
# https://github.com/regolith-linux/regolith-i3-gaps-config/pull/20

mkdir ~/.local/bin
# .profile does this at login, but only if ~/.local/bin exists, which it didn't at login
export PATH="$HOME/.local/bin:$PATH"

echo source ~/.bashrc_local >> ~/.bashrc
source ~/.bashrc_local

# install other software

cd ~/src

git clone https://github.com/plexus/chemacs.git
cd chemacs
./install.sh

cd ~/src
git clone --branch develop https://github.com/syl20bnr/spacemacs

# cd ~/src
# git clone https://github.com/hlissner/doom-emacs
# doom-emacs/bin/doom install

cd
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source ~/.nvm/nvm.sh
nvm install --lts=dubnium
nvm use
npm install --global yarn

# TODO: React Native doku sagt react-naitve-cli besser nicht global installieren sondern über npx benutzen
# npm install --global react-native-cli re-natal

# TODO: https://github.com/drapanjanas/re-natal/pull/228/files

# Android Studio
# cd
# wget -q wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/4.0.0.16/android-studio-ide-193.6514223-linux.tar.gz
# tar xf android-studio-ide-193.6514223-linux.tar.gz
# rm android-studio-ide-193.6514223-linux.tar.gz
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

# set up machtfit dev environment
cd
wget https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh -O.local/bin/boot
chmod 755 ~/.local/bin/boot
cd ~/src/machtfit
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
sudo -u postgres createuser --createdb --superuser markus
make install-pip-dev install-npm build-dev data-init data-demo
