#!/bin/bash

# i3 Vm
# sudo apt install -y compton hsetroot rxvt-unicode xsel rofi fonts-noto fonts-mplus xsettingsd lxappearance scrot viewnior
# sudo apt install -y libgpgme-dev libassuan-dev libbtrfs-dev libdevmapper-dev pkg-config
# blueman

INTERACTIVE_PACKAGES=(
  postfix
)

PACKAGES=(
  apt-file
  arandr
  aria2
  autoconf
  autojump
  automake
  bison
  blueman
  build-essential
  bzip2
  checkinstall
  cmake
  curl
  direnv
  docker.io
  dstat
  exuberant-ctags
  feh
  flatpak
  fonts-symbola
  gawk
  gcc
  git
  gnome-screenshot
  gnome-software-plugin-flatpak
  gnome-tweaks
  gnupg
  gnutls-bin
  grep
  htop
  i3
  i3lock
  i3status
  imagemagick
  jq
  libbcpkix-java
  libbcprov-java
  libbctls-java
  libcap-ng-utils
  libffi-dev
  libfuse3-dev
  libgdbm-dev
  libgnutls28-dev
  libjansson-dev
  libncurses5-dev
  libreadline-dev
  libssl-dev
  libtool-bin
  libxml2-dev
  libxslt-dev
  libyaml-dev
  lm-sensors
  lynx
  make
  materia-gtk-theme
  maven
  mlocate
  ncal
  net-tools
  openjdk-8-jdk
  opensc
  openssh-server
  pandoc
  pasystray
  pavucontrol
  postfix
  rofi
  scrot
  sed
  silversearcher-ag
  sshuttle
  tcpdump
  texlive-fonts-extra
  tmux
  ttf-mscorefonts-installer
  uuid
  uuid-dev
  virtualbox
  virtualbox-guest-additions-iso
  wget
  whois
  xclip
  xdg-desktop-portal-gtk
  xmlto
  zlib1g-dev
)

sudo apt-get update -yyq

echo "${INTERACTIVE_PACKAGES[@]}" | sudo -E xargs apt-get install -yyq

export DEBIAN_FRONTEND=noninteractive
echo "${PACKAGES[@]}" | sudo -E xargs apt-get install -yyq

sudo apt autoremove -yyq

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
