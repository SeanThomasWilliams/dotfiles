#!/bin/bash

set -x

set -eu
set -o pipefail

APPIMAGE_DIR="$HOME/software/neovim-appimage"

rm -rf "$APPIMAGE_DIR"
mkdir -p "$APPIMAGE_DIR"

cd "$APPIMAGE_DIR"
curl -fSsL -O https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract

rm -f "$HOME/bin/nvim"
sudo cp -rv "$APPIMAGE_DIR"/squashfs-root/usr/* /usr/
