#!/bin/bash

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
  blueman
  build-essential
  bzip2
  cec-utils
  checkinstall
  cmake
  compton
  csvkit
  curl
  dconf-editor
  direnv
  dnsmasq
  docker-buildx
  docker.io
  dstat
  dunst
  ethtool
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
  hstr
  htop
  i3
  i3lock
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
  mosh
  ncal
  net-tools
  network-manager-gnome
  network-manager-openconnect-gnome
  nfs-common
  openjdk-8-jdk
  opensc
  openssh-server
  pandoc
  parallel
  pasystray
  pavucontrol
  postfix
  rofi
  rxvt-unicode
  scrot
  sed
  silversearcher-ag
  sshuttle
  suckless-tools
  system-config-printer
  tcpdump
  texlive-fonts-extra
  thunderbird
  tmux
  ttf-mscorefonts-installer
  unzip
  uuid
  uuid-dev
  viewnior
  vim
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

sudo add-apt-repository ppa:keithw/mosh-dev -y

sudo apt-get update -yyq

sudo apt-get install -yyq "${INTERACTIVE_PACKAGES[@]}"

#export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -yyq "${PACKAGES[@]}"

curl -fSsL -O "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb"
sudo apt-get install -yyq ./session-manager-plugin.deb
rm -f session-manager-plugin.deb

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install nvidia drivers
if lspci | grep -q -i nvidia; then
  echo >&2 "Nvidia card detected"
  sudo apt-get install "linux-headers-$(uname -r)"
  curl -fSsL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb -o /tmp/cuda-keyring.deb
  sudo dpkg -i /tmp/cuda-keyring.deb
  rm -f /tmp/cuda-keyring.deb

  sudo apt-get update -yyq
  sudo apt-get install -yyq cuda-toolkit nvidia-container-runtime
fi

sudo apt autoremove -yyq
