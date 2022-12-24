#!/bin/bash

set -eu
set -o pipefail

# Get OS info
source /etc/os-release

NEOVIM_BASE_DIR="$HOME/.local/neovim"

if [[ $ID_LIKE =~ rhel ]]; then
  sudo yum groups install -y Development\ tools
  sudo yum install -y \
   autoconf \
   automake \
   curl \
   gcc \
   gcc-c++ \
   gettext \
   libtool \
   make \
   patch \
   pkgconfig \
   unzip
elif [[ $ID_LIKE =~ debian ]]; then
  echo >&2 "Fill deb in later"
fi

pip install neovim --upgrade

cd ~/software
if [[ ! -d neovim.git ]]; then
  git clone https://github.com/neovim/neovim.git neovim.git
else
  cd ~/software/neovim.git
  git pull
fi
cd ~/software/neovim.git

make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$NEOVIM_BASE_DIR"
make install
ln -sf "$NEOVIM_BASE_DIR/bin/nvim" "$HOME/bin/nvim"
rm -rf ~/software/neovim.git
