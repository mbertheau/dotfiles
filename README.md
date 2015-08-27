These are my dotfiles.

How to install these on a new machine:

cat > ~/.git << EOF
gitdir: src/dotfiles
EOF
git --git-dir=src/dotfiles --work-tree=. init
git remote add origin git@github.com:mbertheau/dotfiles.git
git fetch origin
git reset origin/master

Then inspect changes and apply to working directory as needed.

git add -f file # to add a file to git