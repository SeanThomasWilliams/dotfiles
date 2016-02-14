#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo yum -y install automake gcc gcc-c++ kernel-devel cmake
git submodule update --init --recursive
cd $DIR/../vim/bundle/YouCompleteMe
./install.py --gocode-completer --tern-completer
