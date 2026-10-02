#!/bin/bash
# Install the Neovim release supported by the shared Tree-sitter configuration.
set -euo pipefail

VERSION="v0.11.7"
APPIMAGE="nvim-linux-x86_64.appimage"
APPIMAGE_DIR="$HOME/software/neovim-appimage"

# Keep each complete binary/runtime bundle so existing editors retain their files.
mkdir -p "$APPIMAGE_DIR" "$HOME/bin"
INSTALL_DIR=$(mktemp -d "$APPIMAGE_DIR/$VERSION.XXXXXX")
cd "$INSTALL_DIR"
curl -fSsL -O "https://github.com/neovim/neovim/releases/download/$VERSION/$APPIMAGE"
chmod u+x "$APPIMAGE"
"./$APPIMAGE" --appimage-extract

# Select the bundled runtime, without mixing it with package-owned /usr files.
ln -sfn "$INSTALL_DIR/squashfs-root/usr/bin/nvim" "$HOME/bin/nvim"
printf 'Neovim installed at %s; run hash -r in existing Bash shells.\n' "$HOME/bin/nvim"
