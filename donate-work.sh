cd
if [ -L snap/chromium/common/chromium/SingletonLock ]; then
    echo "The Chromium profile is locked. Quit Chromium, then run this again." >&2
    exit 1
fi
echo "Preparing donation, stand by.."
umask 077
tar cfz /media/psf/Home/donation.tar \
    .ssh/id_* \
    .gnupg \
    .bashrc_work \
    .bash_history \
    .config/pgcli/history \
    .psql_history \
    .psql_history-defaultdb \
    .cursor \
    .local/state/cursor \
    .claude \
    .claude.json \
    .copilot \
    .copilot-cli-access-token \
    .copilot-cli-copilot-token \
    .python_history \
    snap/chromium \
    ./*vpn.conf \
    .aws \
    .aiven-inception.sh \
    .aiven-test-env.json \
    .buildkite-token \
    .grafana-token \
    .wget-hsts \
    doc \
    src
read -p "Donating... Press Enter when finished."
rm /media/psf/Home/donation.tar
