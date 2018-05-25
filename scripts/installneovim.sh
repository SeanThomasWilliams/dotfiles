#/bin/bash

set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p $HOME/bin
curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -o $HOME/bin/nvim
chmod u+x $HOME/bin/nvim
nvim
