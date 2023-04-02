#!/bin/bash

set -eux

VERSION=2023.03
ANACONDA_INSTALLER_NAME="Anaconda3-$VERSION-Linux-x86_64.sh"
ANACONDA_INSTALLER_PATH="$HOME/software/Anaconda3-$VERSION-Linux-x86_64.sh"

rm -rf "$HOME/anaconda3"

mkdir -p "$HOME/software"

if [[ ! -f "$ANACONDA_INSTALLER_PATH" ]]; then
  curl -fSsL "https://repo.continuum.io/archive/$ANACONDA_INSTALLER_NAME" -o "$ANACONDA_INSTALLER_PATH"
fi

bash "$ANACONDA_INSTALLER_PATH" -b

export PATH="$HOME/anaconda3/bin:$PATH"
hash -r

./pip.sh
./generatejupyterconfig.sh
