cd
echo "Preparing donation, stand by.."
tar cfz /media/psf/Home/donation.tar \
    .ssh/id_* \
    .ssh/config \
    .password-store \
    .gnupg \
    .gu \
    .bashrc_work \
    src
read -p "Donating... Press Enter when finished."
rm /media/psf/Home/donation.tar
