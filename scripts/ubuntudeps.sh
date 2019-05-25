#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
#docker.io
PACKAGES="
autoconf
autojump
automake
bzip2
cmake
cmake
curl
direnv
dstat
fuse
gawk
gawk
gcc
gnupg
grep
htop
jq
libfuse2
make
maven
net-tools
openjdk-8-jdk
openssh-server
sed
silversearcher-ag
taskwarrior
tcpdump
tmux
wget
"

sudo apt-get update -yq

echo "$PACKAGES" | sudo -E xargs apt-get install -yq

sudo apt autoremove -yq
