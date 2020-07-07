#!/bin/bash

cd $HOME/software
wget -c https://github.com/git-lfs/git-lfs/releases/download/v2.4.0/git-lfs-linux-amd64-2.4.0.tar.gz
tar -xvf git-lfs-linux-amd64-2.4.0.tar.gz
cd git-lfs-2.4.0
sudo ./install.sh
