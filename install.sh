set -euo pipefail

WORK_OR_HOME=${1:-}

sudo apt purge --yes nano
sudo apt remove --yes apport

# prepare apt to install regolith
wget -qO - https://archive.regolith-desktop.com/regolith.key |
    gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg >/dev/null

echo deb "[arch=arm64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://archive.regolith-desktop.com/ubuntu/stable questing v3.4" |
    sudo tee /etc/apt/sources.list.d/regolith.list

# prepare apt to install gh
wget -qO - https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

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
# pspg: best tabular data pager ever
# curl: in general good to have
# libbz2-dev libreadline-dev libssl-dev libsqlite3-dev: python 3.7 build
# zstd: doom emacs persistent undo history compression/speedup
# editorconfig: editorconfig module in doom emacs
# suckless-tools:d dmenu, for passmenu
# tk-dev: for pyenv to compile Python with tk support for matplotlib UI
# libcairo2-dev: for pip install pycairo
# liblzma-dev: for pyenv to compile Python and not remark that it's without lzma support
# libsdl2-dev: for building python ai stuff with python 3.11
# libsdl2-image-dev: same
# libsdl2-ttf-dev: same
# libjpeg8-dev: same
# libpcsclite-dev: for pip install pyscard
# libportmidi-dev: same
# libsnappy-dev: for pip install python-snappy
# libsystemd-dev: for pip install systemd-python
# libxmlsec1-dev: for pip install xmlsec
# libxslt1-dev: for pip install lxml
# shellcheck: for flycheck in doom emacs
# shfmt: for doom emacs :lang sh formatting
# pipx: to install basedpyright conveniently in its own virtualenv
# distrobox: work environment

sudo apt install --yes \
    chromium-browser \
    clang \
    colordiff \
    curl \
    distrobox \
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
    libbz2-dev \
    libcairo2-dev \
    libjpeg8-dev \
    liblzma-dev \
    libreadline-dev \
    libpcsclite-dev \
    libportmidi-dev \
    libpq-dev \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-ttf-dev \
    libsnappy-dev \
    libssl-dev \
    libsqlite3-dev \
    libsystemd-dev \
    libxmlsec1-dev \
    libxslt1-dev \
    neovim \
    net-tools \
    openjdk-17-jdk \
    pandoc \
    pass \
    pipx \
    poedit \
    postgresql-postgis \
    pspg \
    python3-dev \
    python3-venv \
    regolith-desktop \
    regolith-session-flashback \
    regolith-session-sway \
    ripgrep \
    shellcheck \
    shfmt \
    suckless-tools \
    tk-dev \
    watchman \
    wget

sudo apt upgrade --yes

# clean up
sudo apt --yes autoremove

sudo ln -s /usr/share/fontconfig/conf.avail/10-autohint.conf /etc/fonts/conf.d/

# Fix AppArmor for rootless containers (unix_chkpwd needs CAP_DAC_OVERRIDE)
# https://github.com/roddhjav/apparmor.d/issues/958
sudo tee /etc/apparmor.d/local/unix-chkpwd >/dev/null <<'EOF'
capability dac_override,
EOF
sudo apparmor_parser -r /etc/apparmor.d/unix-chkpwd

# install config files

cd
ln -s src/dotfiles/{.emacs-profiles.el,.emacs-profile,.spacemacs,.gitconfig,.profile_local,.inputrc,.pants.rc} ~/

mkdir -p ~/.config/regolith3
ln -s ../../src/dotfiles/.config/regolith3/Xresources ~/.config/regolith3/Xresources
mkdir -p ~/.config/i3status-rust
ln -s ../../src/dotfiles/.config/i3status-rust/config.toml ~/.config/i3status-rust/config.toml

mkdir -p ~/.local/bin
ln -s ../../src/dotfiles/.local/bin/{4,doomacs,resetmods.py,spacemacs} ~/.local/bin/

cp /usr/share/doc/pass/examples/dmenu/passmenu ~/.local/bin

# TODO: /etc/regolith/i3/config mit workspace_auto_back_and_forth
# https://github.com/regolith-linux/regolith-i3-gaps-config/pull/20

# .profile does this at login, but only if ~/.local/bin exists, which it didn't at login
export PATH="$HOME/.local/bin:$PATH"

echo source ~/.profile_local >>~/.profile
source ~/.profile_local

if [[ $WORK_OR_HOME == "work" ]]; then
    echo source ~/.bashrc_work >>~/.bashrc
    source ~/.bashrc_work
fi

# install other software

cd
git clone https://github.com/plexus/chemacs2.git ~/.config/emacs

# ~/src/dotfiles/install-spacemacs.sh

~/src/dotfiles/install-doom-emacs.sh

cd
git clone --depth 1 --branch v0.40.3 https://github.com/nvm-sh/nvm.git ~/.nvm
echo 'export NVM_DIR="$HOME/.nvm"' >>~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >>~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >>~/.bashrc
source ~/.nvm/nvm.sh
nvm install --lts=jod
nvm alias default 22

# github-copilot-cli
npm install -g @githubnext/github-copilot-cli

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

git clone --depth 1 https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
git clone --depth 1 https://github.com/pyenv/pyenv-doctor.git "$PYENV_ROOT/plugins/pyenv-doctor"
git clone --depth 1 https://github.com/pyenv/pyenv-update.git "$PYENV_ROOT/plugins/pyenv-update"
git clone --depth 1 https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"

echo 'eval "$(pyenv init -)"' >>~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >>~/.bashrc
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.12
pyenv virtualenv 3.12 aiven
.pyenv/versions/aiven/bin/pip install ruff==0.12.5
pipx install basedpyright

~/src/dotfiles/install-uv.sh

echo 'eval "$(github-copilot-cli alias -- "$0")"' >>~/.bashrc
eval "$(github-copilot-cli alias -- "$0")"

~/src/dotfiles/install-schemaspy.sh

~/src/dotfiles/install-vscode.sh

~/src/dotfiles/install-cursor-agent.sh

if [[ $WORK_OR_HOME == "work" ]]; then
    ~/src/dotfiles/install-1password.sh
fi
