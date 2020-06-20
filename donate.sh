cd
tar cf /media/psf/Home/donation.tar .ssh/id_rsa .ssh/id_rsa.pub .ssh/config .password-store .gnupg
read -p "Donating... Press Enter when finished."
rm /media/psf/Home/donation.tar
