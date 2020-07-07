#!/bin/bash -eux

VERSION=2020.02
ANACONDA_INSTALLER="Anaconda3-$VERSION-Linux-x86_64.sh"

cleanup(){
  echo >&2 "Cleaning up..."
  rm -f "$ANACONDA_INSTALLER"
}

trap cleanup EXIT

curl --fail -m 10 -L -O "https://repo.continuum.io/archive/$ANACONDA_INSTALLER"
sh $ANACONDA_INSTALLER -b

export PATH="$HOME/anaconda3/bin:$PATH"
hash -r

./pip.sh
./generatejupyterconfig.sh
