#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -e /etc/yum.repos.d/devtools-2.repo ]; then
    wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
    sudo yum -y install devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-gfortran automake gcc gcc-c++ kernel-devel cmake
fi

git submodule update --init --recursive
cd $DIR/../vim/bundle/YouCompleteMe
git fetch
git checkout master
git pull
git submodule update --init --recursive
./install.py --gocode-completer
