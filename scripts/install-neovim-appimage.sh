#!/bin/bash

set -x

set -eu
set -o pipefail

APPIMAGE="nvim-linux-x86_64.appimage"
APPIMAGE_DIR="$HOME/software/neovim-appimage"

rm -rf "$APPIMAGE_DIR"
mkdir -p "$APPIMAGE_DIR"
cd "$APPIMAGE_DIR"

curl -fSsL -O "https://github.com/neovim/neovim/releases/download/stable/$APPIMAGE"
chmod u+x "$APPIMAGE"
"./$APPIMAGE" --appimage-extract

rm -f "$HOME/bin/nvim"
sudo cp -rv "$APPIMAGE_DIR"/squashfs-root/usr/* /usr/
