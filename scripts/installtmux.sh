#!/bin/bash

set -e

sudo yum -y install ncurses-devel gcc kernel-devel make

mkdir -p $HOME/software
cd $HOME/software

# Get libevent
wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
tar -xvf libevent-2.0.22-stable.tar.gz
cd libevent-2.0.22-stable
./configure --prefix=/usr/local
make -j
sudo make install

# Get tmux
cd $HOME/software
wget https://github.com/tmux/tmux/releases/download/2.1/tmux-2.1.tar.gz
tar -xvf tmux-2.1.tar.gz
cd tmux-2.1
make configure
./configure --prefix=/usr/
make -j
sudo make install

tmux -V
