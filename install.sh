WORK_OR_HOME=$1

sudo apt purge --yes nano

# prepare apt to install regolith
sudo add-apt-repository --yes ppa:regolith-linux/release

# prepare apt to install gh
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages

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

sudo apt install --yes \
     chromium-browser \
     clang \
     colordiff \
     emacs \
     fd-find \
     gettext \
     gh \
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

# clean up
sudo apt --yes autoremove

# install config files

cd
ln -s src/dotfiles/{.emacs-profiles.el,.emacs-profile,.spacemacs,.gitconfig,.bashrc_local} ~/
mkdir -p ~/.config/regolith
ln -s ../../src/dotfiles/.config/regolith/Xresources ~/.config/regolith/Xresources
mkdir -p ~/.local/bin
if [[ $WORK_OR_HOME == "work" ]]; then
    ln -s ../../src/dotfiles/.local/bin/flowdock ~/.local/bin/flowdock
    ln -s ../../src/dotfiles/.local/bin/teams ~/.local/bin/teams
fi

ln -s ../../src/dotfiles/.local/bin/clojurians ~/.local/bin/clojurians

# TODO: /etc/regolith/i3/config mit workspace_auto_back_and_forth
# https://github.com/regolith-linux/regolith-i3-gaps-config/pull/20

# .profile does this at login, but only if ~/.local/bin exists, which it didn't at login
export PATH="$HOME/.local/bin:$PATH"

echo source ~/.bashrc_local >> ~/.bashrc
source ~/.bashrc_local

# vpn
if [[ $WORK_OR_HOME == "work" ]]; then
    sudo mkdir /etc/openvpn/m.bertheau_workstation
    cd ~/Documents/m.bertheau_workstation
    sudo cp *.{crt,key,ovpn} update-systemd-resolved /etc/openvpn/m.bertheau_workstation/
    sudo systemctl restart openvpn
fi

# install other software

cd ~/src

rm -rf chemacs
git clone https://github.com/plexus/chemacs.git
cd chemacs
./install.sh

cd ~/src
rm -rf spacemacs
git clone --branch develop https://github.com/syl20bnr/spacemacs

# cd ~/src
# git clone https://github.com/hlissner/doom-emacs
# doom-emacs/bin/doom install

cd
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source ~/.nvm/nvm.sh
nvm install --lts=dubnium
nvm install --lts=erbium
nvm install --lts=fermium
nvm alias default lts/erbium

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

# set up machtfit dev environment
if [[ $WORK_OR_HOME == "work" ]]; then
    cd

    sudo add-apt-repository --yes ppa:deadsnakes/ppa
    sudo apt-get update
    sudo apt-get install --yes python3.7 python3.7-dev python3.7-venv python3.7-distutils

    sudo -u postgres createuser --superuser markus

    cd ~/src/machtfit
    make dev-setup
fi
