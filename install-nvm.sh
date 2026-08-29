#!/usr/bin/env bash
set -euo pipefail

git clone --depth 1 --branch v0.40.3 https://github.com/nvm-sh/nvm.git ~/.nvm
echo 'export NVM_DIR="$HOME/.nvm"' >>~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >>~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >>~/.bashrc
source ~/.nvm/nvm.sh
nvm install 26
nvm alias default 26

npm install -g @githubnext/github-copilot-cli
echo 'eval "$(github-copilot-cli alias -- "$0")"' >>~/.bashrc
eval "$(github-copilot-cli alias -- "$0")"
