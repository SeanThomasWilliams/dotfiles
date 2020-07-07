#!/bin/bash -eux

VERSION=v12.18.1
DISTRO=linux-x64

cleanup(){
  rm -f "node-$VERSION-$DISTRO.tar.xz"
}

trap cleanup EXIT

curl --fail -m 10 -L -O "https://nodejs.org/dist/$VERSION/node-$VERSION-$DISTRO.tar.xz"

sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf "node-$VERSION-$DISTRO.tar.xz" -C /usr/local/lib/nodejs

for prg in node npm npx; do
  sudo ln -sf "/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/$prg" "/usr/bin/$prg"
done

sudo npm -g install eslint jshint tern yarn neovim
