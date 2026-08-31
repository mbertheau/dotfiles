#!/usr/bin/env bash
set -euo pipefail

# emacs-31 dropped the WebKit < 2.41.92 cap that makes 30.x refuse this
# distro's WebKit. Toolkit is gtk3/X11 to match Ubuntu's emacs-gtk.
src="$HOME/src/emacs"
prefix="$HOME/.local"
repo="https://github.com/emacs-mirror/emacs.git"
branch="emacs-31"
jobs="$(nproc)"

required_features=(
    ACL CAIRO DBUS FREETYPE GIF GLIB GMP GNUTLS GPM GSETTINGS HARFBUZZ
    JPEG LCMS2 LIBOTF LIBSELINUX LIBSYSTEMD LIBXML2 M17N_FLT MODULES
    NATIVE_COMP PDUMPER PNG RSVG SOUND SQLITE3 THREADS TIFF
    TOOLKIT_SCROLL_BARS TREE_SITTER WEBP X11 XINPUT2 XPM GTK3 XWIDGETS
    ZLIB
)

if ! pkg-config --exists webkit2gtk-4.1 gtk+-3.0; then
    echo "missing gtk3 or webkit2gtk-4.1 headers; run install-emacs-build-deps.sh first" >&2
    exit 1
fi

mkdir -p "$HOME/src"
if [[ ! -d "$src/.git" ]]; then
    if [[ -e "$src" ]]; then
        echo "$src exists and is not a git checkout" >&2
        exit 1
    fi
    git clone --branch "$branch" --single-branch "$repo" "$src"
fi

git -C "$src" fetch origin "$branch"
git -C "$src" checkout "$branch"
git -C "$src" merge --ff-only "origin/$branch"

cd "$src"
./autogen.sh
./configure \
    --prefix="$prefix" \
    --with-libsystemd \
    --with-pop=yes \
    --with-sound=alsa \
    --without-gconf \
    --with-mailutils \
    --with-cairo \
    --with-x=yes \
    --with-x-toolkit=gtk3 \
    --with-toolkit-scroll-bars \
    --with-xwidgets \
    --with-native-compilation \
    --with-modules \
    --with-xml2 \
    --with-gnutls \
    --with-png \
    --with-jpeg \
    --with-tiff \
    --with-gif \
    --with-rsvg \
    --with-webp \
    --with-xpm \
    --with-sqlite3 \
    --with-harfbuzz \
    --with-lcms2 \
    --with-libotf \
    --with-m17n-flt \
    --with-selinux \
    --with-gpm \
    --with-dbus \
    --with-gsettings \
    --with-xinput2 \
    --with-tree-sitter \
    --with-threads \
    --with-zlib

make -j"$jobs"
make install

emacs_bin="$prefix/bin/emacs"
features="$("$emacs_bin" --batch --eval '(princ system-configuration-features)' 2>/dev/null)"
echo "features: $features"

missing=()
for feature in "${required_features[@]}"; do
    if [[ " $features " != *" $feature "* ]]; then
        missing+=("$feature")
    fi
done
if ((${#missing[@]})); then
    echo "missing features: ${missing[*]}" >&2
    exit 1
fi
