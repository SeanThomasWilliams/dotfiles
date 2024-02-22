#!/bin/bash

set -euo pipefail

mkdir -p "$HOME/software"
cd "$HOME/software"

rm -rf "$HOME/software/bugwarrior"
git clone https://github.com/GothenburgBitFactory/bugwarrior.git
cd bugwarrior
pip3 install .[all]
rm -rf "$HOME/software/bugwarrior"
