#!/bin/bash -ex

rm -rf tmux-appimage
git clone https://github.com/nelsonenzo/tmux-appimage.git
cd tmux-appimage

#### Set the desired tmux release tag and build
export TMUX_RELEASE_TAG=3.3a
docker build . -t tmux --build-arg TMUX_RELEASE_TAG=$TMUX_RELEASE_TAG

#### extract the appimage file
docker create -ti --name tmuxcontainer tmux bash
docker cp tmuxcontainer:/opt/build/tmux.appimage .
docker rm -f tmuxcontainer

ls -al tmux.appimage
chmod +x tmux.appimage

mkdir -p "$HOME/bin"
mv tmux.appimage "$HOME/bin/tmux"

cd ../
rm -rf tmux-appimage

"$HOME/bin/tmux" -V
