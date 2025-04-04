#!/bin/bash

set -euo pipefail
set -x

mkdir -p "$HOME/software"
cd "$HOME/software"

rm -rf autojump
git clone https://github.com/wting/autojump.git

cd autojump
sudo ./install.py -s
