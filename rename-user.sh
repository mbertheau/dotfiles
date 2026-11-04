#!/usr/bin/env bash
# wget -q https://raw.githubusercontent.com/mbertheau/dotfiles/new-master/rename-user.sh
set -euo pipefail

usage() {
    cat >&2 <<EOF
usage: sudo $0 create
       sudo $0 rename

create, as markus-bertheau: creates the temporary admin user randy-rename.
rename, logged in as randy-rename: renames markus-bertheau to markus.bertheau.
EOF
    exit 2
}

create() {
    if id randy-rename >/dev/null 2>&1; then
        echo "user randy-rename already exists" >&2
        exit 1
    fi
    local rename_command
    rename_command="sudo bash $(realpath "$0") rename"
    useradd --create-home --shell /bin/bash --groups sudo --comment "Randy Rename" randy-rename
    cat >>/home/randy-rename/.bashrc <<EOF

echo "To rename markus-bertheau to markus.bertheau, run:"
echo "    $rename_command"
EOF
    echo "Choose a password for randy-rename:"
    passwd randy-rename
    cat <<EOF
Created randy-rename. Log out, log in as randy-rename, and run:
    $rename_command
EOF
}

rename() {
    if ! id markus-bertheau >/dev/null 2>&1; then
        echo "no user markus-bertheau" >&2
        exit 1
    fi
    if [[ ${SUDO_USER:-} == markus-bertheau ]]; then
        echo "run this as randy-rename, not as markus-bertheau" >&2
        exit 1
    fi
    if id markus.bertheau >/dev/null 2>&1; then
        echo "user markus.bertheau already exists" >&2
        exit 1
    fi
    if [[ -e /home/markus.bertheau ]]; then
        echo "/home/markus.bertheau already exists" >&2
        exit 1
    fi

    # usermod refuses while any process runs as the user, including the systemd --user manager.
    loginctl terminate-user markus-bertheau 2>/dev/null || true
    for _ in $(seq 20); do
        pgrep -u markus-bertheau >/dev/null || break
        sleep 1
    done
    if pgrep -u markus-bertheau >/dev/null; then
        echo "processes of markus-bertheau are still running:" >&2
        ps -fu markus-bertheau >&2
        exit 1
    fi

    usermod --login markus.bertheau markus-bertheau
    if getent group markus-bertheau >/dev/null; then
        groupmod --new-name markus.bertheau markus-bertheau
    fi
    usermod --move-home --home /home/markus.bertheau markus.bertheau

    # Rootless podman looks the user up by name here.
    for f in /etc/subuid /etc/subgid; do
        if [[ -f $f ]]; then
            sed -i "s/^markus-bertheau:/markus.bertheau:/" "$f"
        fi
    done

    if [[ -f /etc/gdm3/custom.conf ]]; then
        sed -i "s/^AutomaticLogin=markus-bertheau\$/AutomaticLogin=markus.bertheau/" /etc/gdm3/custom.conf
    fi

    if grep -rlwF -- markus-bertheau /etc/sudoers /etc/sudoers.d 2>/dev/null; then
        echo "the files above still mention markus-bertheau; edit them with visudo" >&2
    fi

    cat <<EOF
Renamed markus-bertheau to markus.bertheau. Reboot and log in as markus.bertheau.
bootstrap.sh removes randy-rename.
EOF
}

if [[ $EUID -ne 0 ]]; then
    echo "run as root" >&2
    exit 1
fi

case ${1:-} in
create)
    [[ $# -eq 1 ]] || usage
    create
    ;;
rename)
    [[ $# -eq 1 ]] || usage
    rename
    ;;
*)
    usage
    ;;
esac
