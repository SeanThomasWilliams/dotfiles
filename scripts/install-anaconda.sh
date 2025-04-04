#!/bin/bash

set -eux -o pipefail

VERSION=latest
MINICONDA_INSTALLER_NAME="Miniconda3-$VERSION-Linux-x86_64.sh"
MINICONDA_INSTALLER_PATH="$HOME/software/Anaconda3-$VERSION-Linux-x86_64.sh"
MINICONDA_PREFIX="$HOME/anaconda3"

rm -rf "$MINICONDA_PREFIX"

mkdir -p "$HOME/software"

if [[ ! -f "$MINICONDA_INSTALLER_PATH" ]]; then
  curl -fSsL "https://repo.anaconda.com/miniconda/$MINICONDA_INSTALLER_NAME" -o "$MINICONDA_INSTALLER_PATH"
fi

bash "$MINICONDA_INSTALLER_PATH" -m -b -p "$MINICONDA_PREFIX"

export PATH="$MINICONDA_PREFIX/bin:$PATH"
hash -r

./pip.sh
