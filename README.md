1. Install Ubuntu
2. Setup keyboard layout and language settings
3. maybe configure screen blanking time, maybe accessibility -> large text
4. install parallels tools if not done by parallels already during OS installation
5. run full system update
6. wget -q https://raw.githubusercontent.com/mbertheau/dotfiles/new-master/bootstrap.sh
7. bash ./bootstrap.sh work
or bash ./bootstrap.sh home

1. doom sync -u # to fix doom emacs
2. install nerd font from within doom

# Notes
lsp-ruff adheres to .python-version (from pyenv), so if the env specified in the project root has
ruff installed, then lsp-ruff will find and use it.

Then there's fix-pyright in .bashrc_work to set up the virtualenv for the py imports
