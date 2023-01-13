#!/bin/bash

# i3 Vm
# sudo apt install -y compton hsetroot rxvt-unicode xsel rofi fonts-noto fonts-mplus xsettingsd lxappearance scrot viewnior
# sudo apt install -y libgpgme-dev libassuan-dev libbtrfs-dev libdevmapper-dev pkg-config
# blueman

export DEBIAN_FRONTEND=noninteractive

PACKAGES=(
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
  dstat
  exuberant-ctags
  flatpak
  fonts-symbola
  gawk
  gcc
  git
  gnome-screenshot
  gnome-software-plugin-flatpak
  gnome-tweaks
  gnupg
  grep
  htop
  i3
  i3lock
  i3status
  imagemagick
  jq
  libffi-dev
  libfuse3-dev
  libgdbm-dev
  libgnutls28-dev
  libjansson-dev
  libncurses5-dev
  libreadline-dev
  libssl-dev
  libyaml-dev
  make
  materia-gtk-theme
  maven
  mlocate
  neovim
  net-tools
  openjdk-8-jdk
  opensc
  openssh-server
  pandoc
  pasystray
  pavucontrol
  remake
  rofi
  scrot
  sed
  silversearcher-ag
  sshuttle
  taskwarrior
  tcpdump
  texlive-fonts-extra
  tmux
  ttf-mscorefonts-installer
  uuid
  uuid-dev
  wget
  xdg-desktop-portal-gtk
  zlib1g-dev
  lynx
  xmlto
)

sudo apt-get update -yyq

echo "${PACKAGES[@]}" | sudo -E xargs apt-get install -yyq

sudo apt autoremove -yyq

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
