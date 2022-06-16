#!/bin/bash -eux

VERSION=v14.17.6
DISTRO=linux-x64

cleanup(){
  rm -f "node-$VERSION-$DISTRO.tar.xz"
}

trap cleanup EXIT
curl -fSsL -O "https://nodejs.org/dist/$VERSION/node-$VERSION-$DISTRO.tar.xz"

sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf "node-$VERSION-$DISTRO.tar.xz" -C /usr/local/lib/nodejs

for prg in node npm npx; do
  sudo ln -sf "/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/$prg" "/usr/bin/$prg"
done
