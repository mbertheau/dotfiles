cd
echo "Preparing donation, stand by.."
tar cfz /media/psf/Home/donation.tar \
    .ssh/id_rsa \
    .ssh/id_rsa.pub \
    .ssh/config \
    .password-store \
    .gnupg \
    .thunderbird \
    src
read -p "Donating... Press Enter when finished."
rm /media/psf/Home/donation.tar
