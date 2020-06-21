sudo apt purge --yes nano

# install regolith

sudo add-apt-repository ppa:regolith-linux/release
sudo apt install --yes \
     chromium-browser \
     clang \ # weiss nicht mehr
     colordiff \
     emacs \
     fd-find \ # doom emacs
     i3xrocks-cpu-usage \
     i3xrocks-keyboard-layout \
     i3xrocks-key-indicator \
     i3xrocks-net-traffic \
     i3xrocks-nm-vpn \
     i3xrocks-openvpn \
     i3xrocks-time \
     leiningen \
     neovim \ # sensible editor for the terminal
     openjdk-8-jdk \
     pandoc \ # spacemacs markdown
     pass \
     regolith-desktop \
     ripgrep \
     tar \
     watchman \ # react native
     libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 \ # Android Studio

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
npm install --global yarn react-native-cli re-natal

# TODO: https://github.com/drapanjanas/re-natal/pull/228/files

# Android Studio
cd
wget -q wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/4.0.0.16/android-studio-ide-193.6514223-linux.tar.gz
tar xf android-studio-ide-193.6514223-linux.tar.gz
rm android-studio-ide-193.6514223-linux.tar.gz
