#!/bin/bash -ex

mkdir -p "$HOME/bin"
curl -L "https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage" -o "$HOME/bin/nvim.temp"
chmod u+x "$HOME/bin/nvim.temp"
mv "$HOME/bin/nvim.temp" "$HOME/bin/nvim"
"$HOME/bin/nvim" --version
