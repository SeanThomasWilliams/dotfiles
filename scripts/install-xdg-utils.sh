#!/bin/bash

set -euo pipefail

if [[ ! -d "$HOME/software/xdg-utils" ]]; then
  git clone https://gitlab.freedesktop.org/xdg/xdg-utils.git "$HOME/software/xdg-utils"
fi

cd "$HOME/software/xdg-utils"
git fetch
git reset --hard origin/master

./configure
cd scripts
make scripts
sudo make install
