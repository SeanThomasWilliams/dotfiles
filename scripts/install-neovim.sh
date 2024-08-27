#!/bin/bash

set -x

set -eu
set -o pipefail

unset MAKEFLAGS

# Get OS info
mkdir -p "$HOME/software"

# Check if pip3 is installed
if ! command -v pip3 &> /dev/null; then
  echo "pip3 could not be found, please install it first."
  exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
  echo "git could not be found, please install it first."
  exit 1
fi

pip3 install neovim --upgrade

cd ~/software
if [[ ! -d neovim.git ]]; then
  git clone https://github.com/neovim/neovim.git neovim.git
fi
cd ~/software/neovim.git
git fetch --tags
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout $latest_tag

rm -f ~/anaconda3/bin/libtool*

make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DUSE_BUNDLED_LUAJIT=ON -DUSE_BUNDLED_LUAROCKS=ON"

sudo make install
if sudo make install; then
  sudo rm -rf "$HOME/software/neovim.git"
else
  echo "Installation failed. The repository has not been removed for debugging purposes."
fi
