#!/usr/bin/env bash
# Rebuild Ubuntu's libwlroots-0.19 with the virtio-gpu hardware-cursor
# fix, install it, and hold it against archive upgrades.
set -euo pipefail
export PATH="/usr/bin:/usr/sbin:/bin"

script_dir=$(cd "$(dirname "$0")" && pwd)
patch_file=$script_dir/fill-hardware-cursors-from-dumb-buffers.patch

archive_ver=$(apt-cache madison libwlroots-0.19 |
    awk -F'|' '/ubuntu.com/ { gsub(/ /, "", $2); print $2; exit }')
wanted=${archive_ver}+cursor1
installed=$(dpkg-query -W -f '${Version}' libwlroots-0.19 2>/dev/null || true)

if [ "$installed" = "$wanted" ]; then
    sudo apt-mark hold libwlroots-0.19
    exit 0
fi

sudo apt-get build-dep --yes wlroots
sudo apt-get install --yes quilt pnp.ids devscripts

workdir=$(mktemp -d "${TMPDIR:-/tmp}/fix-wlroots.XXXXXX")
trap 'rm -rf "$workdir"' EXIT
cd "$workdir"

apt-get source "wlroots=${archive_ver}"
cd wlroots-*/
export QUILT_PATCHES=debian/patches
cp "$patch_file" debian/patches/fill-hardware-cursors-from-dumb-buffers.patch
echo fill-hardware-cursors-from-dumb-buffers.patch >>debian/patches/series
quilt push

export DEBFULLNAME="${DEBFULLNAME:-Markus Bertheau}"
export DEBEMAIL="${DEBEMAIL:-mbertheau@localhost}"
codename=$(. /etc/os-release && echo "$VERSION_CODENAME")
dch --newversion "$wanted" --distribution "$codename" --force-distribution \
    "Fill hardware cursors via DRM dumb buffers so virtio-gpu's host overlay can display them."

dpkg-buildpackage -us -uc -b
sudo dpkg --install "$workdir/libwlroots-0.19_${wanted}_$(dpkg --print-architecture).deb"
sudo apt-mark hold libwlroots-0.19
