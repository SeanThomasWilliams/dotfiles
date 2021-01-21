#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
#docker.io
PACKAGES=(
  aria2
  autoconf
  autojump
  automake
  bzip2
  cmake
  ctags
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
  neovim
  net-tools
  openjdk-8-jdk
  openssh-server
  remake
  ruby
  ruby-dev
  sed
  silversearcher-ag
  taskwarrior
  tcpdump
  tmux
  wget
)

sudo apt-get update -yyq

echo "${PACKAGES[@]}" | sudo -E xargs apt-get install -yyq

sudo apt autoremove -yyq
