#!/bin/bash

set -eux -o pipefail

GIT_LFS_VERSION="3.6.1"

mkdir -p "$HOME/software"
cd "$HOME/software"

wget -c "https://github.com/git-lfs/git-lfs/releases/download/v$GIT_LFS_VERSION/git-lfs-linux-amd64-v$GIT_LFS_VERSION.tar.gz"
tar -xvf "git-lfs-linux-amd64-v$GIT_LFS_VERSION.tar.gz"

cd "$HOME/software/git-lfs-$GIT_LFS_VERSION"
sudo ./install.sh
rm -f "$HOME/software/git-lfs-linux-amd64-v$GIT_LFS_VERSION.tar.gz"
rm -rf "$HOME/software/git-lfs-$GIT_LFS_VERSION"
