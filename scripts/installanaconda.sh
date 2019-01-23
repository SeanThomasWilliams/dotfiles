#!/bin/bash

VERSION=5.1.0
CONDA="Anaconda3-$VERSION-Linux-x86_64.sh"

wget -c "https://repo.continuum.io/archive/$CONDA"
sh $CONDA -b

./pip.sh
./generatejupyterconfig.sh

rm -f $CONDA
