sudo apt purge --yes nano

# install regolith

sudo add-apt-repository ppa:regolith-linux/release

# clang: weiss nicht mehr
# fd-find: doom emacs
# neovim: sensible editor for the terminal
# net-tools: for netstat
# pandoc: seacemacs markdown
# watchman: react-native
# libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386: Android Studio

sudo apt install --yes \
     chromium-browser \
     clang \
     colordiff \
     emacs \
     fd-find \
     i3xrocks-cpu-usage \
     i3xrocks-keyboard-layout \
     i3xrocks-key-indicator \
     i3xrocks-net-traffic \
     i3xrocks-nm-vpn \
     i3xrocks-openvpn \
     i3xrocks-time \
     leiningen \
     neovim \
     net-tools \
     openjdk-8-jdk \
     pandoc \
     pass \
     regolith-desktop \
     ripgrep \
     tar \
     watchman \
     libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

sudo snap install --classic hub

# this is necessary until https://github.com/regolith-linux/regolith-desktop/pull/428 is released
sudo apt purge --yes unclutter-startup

# install config files

cd
ln -s src/dotfiles/{.emacs-profiles.el,.emacs-profile,.spacemacs,.gitconfig} ~/
mkdir -p ~/.config/regolith
ln -s ~/src/dotfiles/.config/regolith/Xresources ~/.config/regolith/Xresources

# TODO: /etc/regolith/i3/config mit workspace_auto_back_and_forth
# https://github.com/regolith-linux/regolith-i3-gaps-config/pull/20

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
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.nvm/nvm.sh
nvm install stable
# TODO: React Native doku sagt react-naitve-cli besser nicht global installieren sondern über npx benutzen
npm install --global yarn react-native-cli re-natal

# TODO: https://github.com/drapanjanas/re-natal/pull/228/files

# Android Studio
cd
wget -q wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/4.0.0.16/android-studio-ide-193.6514223-linux.tar.gz
tar xf android-studio-ide-193.6514223-linux.tar.gz
rm android-studio-ide-193.6514223-linux.tar.gz
cat >> ~/.bashrc <<EOF
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
EOF
# allow access to my Android Phone
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2a70", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android-usb.rules
echo "Set up Android Studio for React Native according to https://reactnative.dev/docs/environment-setup"
