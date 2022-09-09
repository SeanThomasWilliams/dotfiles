#!/bin/bash

# i3 Vm
# sudo apt install -y compton hsetroot rxvt-unicode xsel rofi fonts-noto fonts-mplus xsettingsd lxappearance scrot viewnior
# sudo apt install -y libgpgme-dev libassuan-dev libbtrfs-dev libdevmapper-dev pkg-config
# blueman

export DEBIAN_FRONTEND=noninteractive

PACKAGES=(
  aria2
  autoconf
  autojump
  automake
  build-essential
  bzip2
  checkinstall
  cmake
  curl
  direnv
  dstat
  exuberant-ctags
  fuse
  gawk
  gawk
  gcc
  git
  gnupg
  grep
  htop
  i3
  i3lock
  i3status
  jq
  libfuse2
  libgnutls28-dev
  libssl-dev
  make
  maven
  mlocate
  neovim
  net-tools
  openjdk-8-jdk
  opensc
  openssh-server
  remake
  rofi
  ruby
  ruby-dev
  sed
  silversearcher-ag
  sshuttle
  taskwarrior
  tcpdump
  tmux
  uuid
  uuid-dev
  wget
  zlib1g-dev
  blueman
  pasystray
  pavucontrol
  imagemagick
  scrot
  arandr
  pandoc
  texlive-fonts-extra
  gnome-screenshot

  materia-gtk-theme
  gnome-tweaks
  xdg-desktop-portal-gtk
  flatpak
  gnome-software-plugin-flatpak

  ttf-mscorefonts-installer # EULA
)

sudo apt-get update -yyq

echo "${PACKAGES[@]}" | sudo -E xargs apt-get install -yyq

sudo apt autoremove -yyq

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install io.github.realmazharhusain.GdmSettings -y
