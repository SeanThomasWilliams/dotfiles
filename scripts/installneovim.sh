#/bin/bash

set -e
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#sudo yum -y install automake gcc gcc-c++ kernel-devel cmake
mkdir -p $HOME/software
cd $HOME/software
if [[ ! -d neovim ]]; then
    git clone https://github.com/neovim/neovim
    cd neovim
else
    cd neovim
    git checkout master
    git pull
fi

sudo yum -y install libtool automake autoconf cmake gcc-c++ gcc

rm -rf .deps
mkdir -p .deps
cd .deps
cmake ../third-party
make -j $(nproc)

cd ..
mkdir -p build
cd build
cmake ..
make -j $(nproc)

sudo make install
make clean
