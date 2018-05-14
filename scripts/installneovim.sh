#/bin/bash

set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

debianinstall(){
    which apt &> /dev/null && \
        sudo apt-get install automake autoconf libtool libtool-bin
}

rhelinstall(){
    which yum &> /dev/null && \
        sudo yum -y install libtool automake autoconf cmake gcc-c++ gcc kernel-devel
}

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

# Install packages
debianinstall
rhelinstall

make
sudo make install
