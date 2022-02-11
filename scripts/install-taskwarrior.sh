#!/bin/bash

set -eux

TASKWARRIOR_VERSION="2.6.1"
TASKWARRIOR_TARBALL="task-${TASKWARRIOR_VERSION}.tar.gz"

mkdir -p ~/software
cd ~/software

rm -rf "task-${TASKWARRIOR_VERSION}"

if [[ ! -f "$TASKWARRIOR_TARBALL" ]]; then
  curl -fSsL -O "https://taskwarrior.org/download/$TASKWARRIOR_TARBALL"
fi

tar -xvf "$TASKWARRIOR_TARBALL"

cd "task-${TASKWARRIOR_VERSION}"

sudo apt -y install libgnutls28-dev uuid-dev

sudo apt -y remove taskwarrior

cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=release .

make -j8

sudo make install
