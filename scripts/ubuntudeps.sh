#!/bin/bash

# i3 Vm
# sudo apt install -y compton hsetroot rxvt-unicode xsel rofi fonts-noto fonts-mplus xsettingsd lxappearance scrot viewnior
# sudo apt install -y libgpgme-dev libassuan-dev libbtrfs-dev libdevmapper-dev pkg-config
# blueman

export DEBIAN_FRONTEND=noninteractive
#docker.io
PACKAGES=(
  aria2
  autoconf
  autojump
  automake
  bzip2
  cmake
  curl
  direnv
  dstat
  exuberant-ctags
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
