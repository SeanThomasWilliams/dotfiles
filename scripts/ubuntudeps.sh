#!/bin/bash

# i3 Vm
# sudo apt install -y compton hsetroot rxvt-unicode xsel rofi fonts-noto fonts-mplus xsettingsd lxappearance scrot viewnior
# sudo apt install -y libgpgme-dev libassuan-dev libbtrfs-dev libdevmapper-dev pkg-config
# blueman



INTERACTIVE_PACKAGES=(
  postfix
)

PACKAGES=(
  amazon-ecr-credential-helper
  apt-file
  arandr
  aria2
  autoconf
  autojump
  automake
  baobab
  bison
  blueman
  build-essential
  bzip2
  cec-utils
  checkinstall
  cmake
  compton
  curl
  direnv
  dstat
  dunst
  exuberant-ctags
  feh
  flatpak
  fonts-mplus
  fonts-noto
  fonts-symbola
  gawk
  gcc
  gettext
  git
  gnome-screenshot
  gnome-software-plugin-flatpak
  gnome-tweaks
  gnupg
  gnutls-bin
  grep
  hsetroot
  htop
  i3
  i3lock
  i3lock
  i3status
  i3status
  i3-wm
  imagemagick
  jq
  libaio1
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
  libnss3-tools
  libreadline-dev
  libssl-dev
  libtool-bin
  libxml2-dev
  libxslt-dev
  libyaml-dev
  lm-sensors
  lxappearance
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
  rofi
  rxvt-unicode
  scrot
  scrot
  sed
  silversearcher-ag
  sshuttle
  suckless-tools
  tcpdump
  texlive-fonts-extra
  tmux
  ttf-mscorefonts-installer
  unzip
  uuid
  uuid-dev
  viewnior
  virtualbox
  virtualbox-guest-additions-iso
  wget
  whois
  xclip
  xdg-desktop-portal-gtk
  xmlto
  xsel
  xsettingsd
  zlib1g-dev
)

sudo apt-get update -yyq

echo "${INTERACTIVE_PACKAGES[@]}" | sudo -E xargs apt-get install -yyq

#export DEBIAN_FRONTEND=noninteractive
echo "${PACKAGES[@]}" | sudo -E xargs apt-get install -yyq

sudo apt autoremove -yyq

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
