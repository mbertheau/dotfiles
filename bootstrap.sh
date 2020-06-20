# wget -q https://raw.githubusercontent.com/mbertheau/dotfiles/new-master/bootstrap.sh
# set up ssh

read -p "Make sure the donation is ready, then press Enter."
tar xf /media/psf/Home/donation.tar
echo "Donation accepted."

sudo apt install --yes git

mkdir ~/src
cd ~/src
git clone git@github.com:mbertheau/dotfiles.git
cd ~/src/dotfiles
git checkout new-master

cd
~/src/dotfiles/install.sh
