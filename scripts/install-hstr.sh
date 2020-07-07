#!/bin/bash -eux

mkdir -p "$HOME/software"
cd "$HOME/software"
sudo apt install -y automake gcc make libncursesw5-dev libreadline-dev pkg-config
git clone https://github.com/dvorka/hstr.git
cd hstr/build/tarball && ./tarball-automake.sh && cd ../..
./configure
make
sudo make install
