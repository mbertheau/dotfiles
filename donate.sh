cd
echo "Preparing donation, stand by.."
umask 077
tar cfz /media/psf/Home/donation.tar \
    .ssh/id_* \
    .ssh/config \
    .password-store \
    .gnupg \
    .bash_history \
    .config/pgcli/history \
    .lesshst \
    .psql_history \
    .grok \
    .cursor \
    .python_history \
    snap/chromium \
    .wget-hsts \
    src
read -p "Donating... Press Enter when finished."
rm /media/psf/Home/donation.tar
