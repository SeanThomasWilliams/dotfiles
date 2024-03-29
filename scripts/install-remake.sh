#!/bin/bash

set -eu
set -o pipefail

# Get OS info
source /etc/os-release

if [[ $ID_LIKE =~ rhel ]]; then
  sudo yum install -y \
    git gcc pkgconfig autoconf automake gettext gettext-devel readline-devel make guile lzip texinfo uconv
elif [[ $ID_LIKE =~ debian ]]; then
  sudo apt-get install -y \
    git gcc pkg-config autoconf automake autopoint gettext libreadline-dev make guile-2.2 texinfo lzip
fi

mkdir -p ~/gocode/src/github.com/rocky
cd ~/gocode/src/github.com/rocky

if [[ ! -d remake ]]; then
  git clone https://github.com/rocky/remake
fi

cd ~/gocode/src/github.com/rocky/remake
git fetch
git checkout remake-4-3
git reset --hard remake-4-3
git branch

$SHELL ./autogen.sh

make && make check
sudo make install
