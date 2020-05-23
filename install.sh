# install regolith

sudo add-apt-repository ppa:regolith-linux/release
sudo apt install \
     chromium-browser \
     clang \
     default-jdk \
     emacs \
     fd-find \
     git \
     i3xrocks-cpu-usage \
     i3xrocks-keyboard-layout \
     i3xrocks-key-indicator \
     i3xrocks-net-traffic \
     i3xrocks-nm-vpn \
     i3xrocks-openvpn \
     i3xrocks-time \
     neovim \
     regolith-desktop \
     ripgrep \
     tar \


mkdir ~/src

echo download dotfiles to ~/src/dotfiles
exit

cd ~/src/dotfiles
ln .emacs-profiles.el ~/
ln .emacs-profile ~/
ln .spacemacs ~/

cd ~/src

git clone https://github.com/plexus/chemacs.git
cd chemacs
./install.sh

cd ~/src
git clone https://github.com/syl20bnr/spacemacs
git checkout develop

cd ~/src
git clone https://github.com/hlissner/doom-emacs
doom-emacs/bin/doom install
