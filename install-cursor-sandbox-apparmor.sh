#!/usr/bin/env bash
set -euo pipefail

# Cursor's .deb ships /etc/apparmor.d/cursor-sandbox with userns commented out and
# no dac_override. On Ubuntu 25.10 (AppArmor 5, apparmor_restrict_unprivileged_userns=1)
# agent terminals then fail at unshare. A Cursor upgrade overwrites this file.

. /etc/os-release
if [[ ${ID:-} != ubuntu || ${VERSION_ID:-} != 25.10 ]]; then
    echo "Skipping Cursor sandbox AppArmor profile (Ubuntu 25.10 only; this is ${PRETTY_NAME:-unknown})." >&2
    exit 0
fi

profile_body() {
    local name=$1 helper=$2
    cat <<EOF

profile ${name} ${helper} {
  file,
  /** ix,

  capability sys_admin,
  capability net_admin,
  capability chown,
  capability setuid,
  capability setgid,
  capability setpcap,
  capability dac_override,

  userns,
  network,
  mount,
  remount,
  umount,

  signal (receive) peer=unconfined,

  ${helper} mr,

  include if exists <local/cursor-sandbox>
}
EOF
}

sudo tee /etc/apparmor.d/cursor-sandbox >/dev/null <<EOF
abi <abi/4.0>,
$(profile_body cursor_sandbox /usr/share/cursor/resources/app/resources/helpers/cursorsandbox)
$(profile_body cursor_sandbox_remote '/home/*/.cursor-server/bin/*/*/resources/helpers/cursorsandbox')
$(profile_body cursor_sandbox_agent_cli '/home/*/.local/share/cursor-agent/versions/*/cursorsandbox')
EOF

sudo apparmor_parser -r /etc/apparmor.d/cursor-sandbox

helper=/usr/share/cursor/resources/app/resources/helpers/cursorsandbox
if [[ -x $helper ]]; then
    if [[ $(id -u) -eq 0 && -n ${SUDO_USER:-} ]]; then
        preflight_user=$SUDO_USER
        preflight_home=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    else
        preflight_user=$(id -un)
        preflight_home=$HOME
    fi
    policy=$(mktemp)
    trap 'rm -f "$policy"' EXIT
    # additionalReadonlyPaths is a path -> glob[] map, not a path list.
    cat >"$policy" <<JSON
{"sandbox":{"type":"workspace_readwrite","cwd":"$preflight_home","readBoundary":"system","hardcodedReadPaths":[],"additionalReadonlyPaths":{},"networkAccess":false,"additionalReadwritePaths":[],"disableTmpWrite":false}}
JSON
    chown "$preflight_user" "$policy"
    # Root can unshare without the AppArmor userns rule, so preflight must run as the user.
    if [[ $(id -un) == "$preflight_user" ]]; then
        "$helper" --policy "$policy" --preflight-only -- /bin/true
    elif [[ $(id -u) -eq 0 ]]; then
        runuser -u "$preflight_user" -- "$helper" --policy "$policy" --preflight-only -- /bin/true
    else
        sudo -u "$preflight_user" -- "$helper" --policy "$policy" --preflight-only -- /bin/true
    fi
fi

echo "Cursor sandbox AppArmor profile loaded. Fully quit and reopen Cursor for agent terminals to pick it up."
