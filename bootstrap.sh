# wget -q https://raw.githubusercontent.com/mbertheau/dotfiles/new-master/bootstrap.sh
# set up ssh

# cache sudo password in the beginning so we don't have to wait for it later in the process
sudo echo

read -p "Make sure the donation is ready, then press Enter."
tar xfz /media/psf/Home/donation.tar
echo "Donation accepted."

# sudo apt install --yes git

# mkdir -p ~/src
# cd ~/src
# git clone git@github.com:mbertheau/dotfiles.git
# cd ~/src/dotfiles
# git checkout new-master

cd
~/src/dotfiles/install.sh
