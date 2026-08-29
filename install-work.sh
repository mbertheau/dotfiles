#!/usr/bin/env bash
set -euo pipefail

echo source ~/.bashrc_work >>~/.bashrc
source ~/.bashrc_work

source ~/.profile_local
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv virtualenv 3.13 aiven
"$HOME/.pyenv/versions/aiven/bin/pip" install ruff==0.12.5

if [[ ! -e ~/src/aiven-agent ]]; then
    git clone git@github.com:mbertheau/aiven-agent.git ~/src/aiven-agent
fi
~/src/aiven-agent/install.sh

~/src/dotfiles/install-1password.sh
~/src/dotfiles/install-vault.sh
