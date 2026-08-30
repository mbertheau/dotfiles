#!/usr/bin/env bash
# Rebuild Regolith's sway session packages so gnome-session autostart
# sees WAYLAND_DISPLAY before READY, install them, and hold them
# against archive upgrades.
set -euo pipefail
export PATH="/usr/bin:/usr/sbin:/bin"

script_dir=$(cd "$(dirname "$0")" && pwd)
patch_file=$script_dir/publish-display-env-to-gnome-session.patch
src_pkg=regolith-wm-config
packages=(regolith-sway-dbus-activation regolith-sway-root-config)

archive_ver=$(apt-cache madison "$src_pkg" |
    awk -F'|' '/regolith-desktop.com/ { gsub(/ /, "", $2); print $2; exit }')
wanted=${archive_ver}+setenv1

all_wanted=true
for pkg in "${packages[@]}"; do
    installed=$(dpkg-query -W -f '${Version}' "$pkg" 2>/dev/null || true)
    if [ "$installed" != "$wanted" ]; then
        all_wanted=false
        break
    fi
done
if $all_wanted; then
    sudo apt-mark hold "${packages[@]}"
    exit 0
fi

src_list=/etc/apt/sources.list.d/regolith.list
if [ -f "$src_list" ] && ! grep -q '^deb-src ' "$src_list"; then
    grep '^deb ' "$src_list" | sed 's/^deb /deb-src /' | sudo tee -a "$src_list" >/dev/null
    sudo apt-get update
fi

sudo apt-get build-dep --yes "$src_pkg"
sudo apt-get install --yes quilt devscripts

workdir=$(mktemp -d "${TMPDIR:-/tmp}/fix-regolith-wm-config.XXXXXX")
trap 'rm -rf "$workdir"' EXIT
cd "$workdir"

apt-get source "${src_pkg}=${archive_ver}"
cd "${src_pkg}"-*/
export QUILT_PATCHES=debian/patches
mkdir -p debian/patches
cp "$patch_file" debian/patches/publish-display-env-to-gnome-session.patch
echo publish-display-env-to-gnome-session.patch >>debian/patches/series
quilt push
chmod +x scripts/regolith-sway-publish-display-env
echo 'scripts/regolith-sway-publish-display-env usr/bin' >>debian/regolith-sway-dbus-activation.install

export DEBFULLNAME="${DEBFULLNAME:-Markus Bertheau}"
export DEBEMAIL="${DEBEMAIL:-mbertheau@localhost}"
codename=$(. /etc/os-release && echo "$VERSION_CODENAME")
dch --newversion "$wanted" --distribution "$codename" --force-distribution \
    "Publish compositor display env to gnome-session before signaling READY."

dpkg-buildpackage -us -uc -b

arch=$(dpkg --print-architecture)
debs=()
for pkg in "${packages[@]}"; do
    debs+=("$workdir/${pkg}_${wanted}_${arch}.deb")
done
sudo dpkg --install "${debs[@]}"
sudo apt-mark hold "${packages[@]}"
