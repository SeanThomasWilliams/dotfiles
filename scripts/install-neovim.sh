#!/bin/bash

set -x

set -eu
set -o pipefail

unset MAKEFLAGS

# Get OS info
mkdir -p "$HOME/software"

pip install neovim --upgrade

cd ~/software
if [[ ! -d neovim.git ]]; then
  git clone https://github.com/neovim/neovim.git neovim.git
fi
cd ~/software/neovim.git
git checkout stable

rm -f ~/anaconda3/bin/libtool*

make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DUSE_BUNDLED_LUAJIT=ON -DUSE_BUNDLED_LUAROCKS=ON"

sudo make install
rm -rf ~/software/neovim.git
