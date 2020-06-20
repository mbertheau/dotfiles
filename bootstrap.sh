# set up ssh

mkdir --mode=700 ~/.ssh

touch ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

echo "Enter ~/.ssh/id_rsa"
cat > ~/.ssh/id_rsa

touch ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/id_rsa.pub

echo "Enter ~/.ssh/id_rsa.pub"
cat > ~/.ssh/id_rsa.pub

sudo apt install git

mkdir ~/src
git clone git@github.com:mbertheau/dotfiles.git
git checkout new-master

cd
~/src/dotfiles/install.sh
