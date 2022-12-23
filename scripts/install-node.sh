#!/bin/bash -eux

VERSION=v16.19.0
DISTRO=linux-x64

node_packages=(
  eslint
  jshint
  neovim
  tern
)

cleanup(){
  rm -f "node-$VERSION-$DISTRO.tar.xz"
}

trap cleanup EXIT
curl -fSsL -O "https://nodejs.org/dist/$VERSION/node-$VERSION-$DISTRO.tar.xz"

sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf "node-$VERSION-$DISTRO.tar.xz" -C /usr/local/lib/nodejs
sudo /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/npm install -g yarn

for prg in node npm npx yarn; do
  sudo ln -sf "/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/$prg" "/usr/bin/$prg"
done

/usr/bin/node --version
/usr/bin/npm --version
/usr/bin/npx --version

sudo npm install -g npm
sudo npm prefix
sudo npm install -g "${node_packages[@]}"
yarn global add "${node_packages[@]}"
