# wget -q https://raw.githubusercontent.com/mbertheau/dotfiles/new-master/bootstrap.sh
set -euo pipefail

# set up ssh

# cache sudo password in the beginning so we don't have to wait for it later in the process
sudo echo

if id randy-rename >/dev/null 2>&1; then
    sudo userdel randy-rename
    sudo rm -rf /home/randy-rename
fi

read -p "Make sure the donation is ready, then press Enter."
echo -n "Reading donation..."
tar xfz /media/psf/Home/donation.tar
echo
echo "Donation accepted."

read -p "Take a snapshot now, then press Enter."

sudo apt install --yes git

# https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cat >>~/.ssh/known_hosts <<'EOF'
github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
EOF

mkdir -p ~/src
cd ~/src
rm -rf dotfiles
git clone git@github.com:mbertheau/dotfiles.git
cd ~/src/dotfiles
git checkout new-master

cd
~/src/dotfiles/install.sh
if [[ ${1:-} == "work" ]]; then
    ~/src/dotfiles/install-work.sh
else
    ~/src/dotfiles/install-home.sh
fi
