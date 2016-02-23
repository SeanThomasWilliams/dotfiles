#/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#sudo yum -y install automake gcc gcc-c++ kernel-devel cmake
mkdir -p $HOME/software
cd $HOME/software
if [[ ! -d neovim ]]; then
    git clone https://github.com/neovim/neovim
fi

sudo yum -y install libtool automake autoconf
cd neovim
make clean
make -j $(nproc)
sudo make install
