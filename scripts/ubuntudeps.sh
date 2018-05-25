#!/bin/bash

sudo apt-get update

sudo apt-get install -y openjdk-8-jdk make cmake gcc automake autoconf \
    curl wget tmux bzip2 taskwarrior cmake gnupg \
    gawk openssh-server tcpdump net-tools maven htop \
    dstat docker.io autojump jq sed gawk grep silversearcher-ag

sudo apt autoremove
