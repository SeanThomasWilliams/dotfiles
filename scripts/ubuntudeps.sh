#!/bin/bash

sudo apt-get update

sudo apt-get install -y openjdk-8-jdk make cmake gcc automake autoconf \
    curl wget tmux neovim bzip2 taskwarrior cmake gpg \
    gawk openssh-server tcpdump net-tools maven htop \
    dstat docker.io

sudo apt autoremove
