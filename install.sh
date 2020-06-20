sudo apt purge --yes nano

# install regolith

sudo add-apt-repository ppa:regolith-linux/release
sudo apt install --yes \
     chromium-browser \
     clang \
     default-jdk \
     emacs \
     fd-find \
     i3xrocks-cpu-usage \
     i3xrocks-keyboard-layout \
     i3xrocks-key-indicator \
     i3xrocks-net-traffic \
     i3xrocks-nm-vpn \
     i3xrocks-openvpn \
     i3xrocks-time \
     neovim \
     pandoc \
     regolith-desktop \
     ripgrep \
     tar \
     watchman \

     sudo snap install --classic hub

# install config files

cd
ln -s src/dotfiles/{.emacs-profiles.el,.emacs-profile,.spacemacs} ~/
mkdir -p ~/.config/regolith
ln -s ~/src/dotfiles/.config/regolith/Xresources ~/.config/regolith/Xresources

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
npm install --global yarn react-native-cli
