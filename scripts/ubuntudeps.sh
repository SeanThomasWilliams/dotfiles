#!/bin/bash

set -x
set -euo pipefail

install_docker(){
  # Add Docker's official GPG key:
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -yyq
  sudo apt-get remove -yyq docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
  sudo apt-get install -yyq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

install_aws_session_manager(){
  curl -fSsL -O "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb"
  sudo apt-get install -yyq ./session-manager-plugin.deb
  rm -f ./session-manager-plugin.deb
}

INTERACTIVE_PACKAGES=(
  postfix
)

CLI_PACKAGES=(
  amazon-ecr-credential-helper
  apt-file
  aria2
  autoconf
  autojump
  automake
  bison
  build-essential
  bzip2
  ca-certificates
  checkinstall
  cmake
  csvkit
  curl
  direnv
  dnsmasq
  dstat
  ethtool
  exuberant-ctags
  feh
  fonts-mplus
  fonts-noto
  fonts-symbola
  fzf
  gawk
  gcc
  gettext
  git
  gnupg
  gnutls-bin
  grep
  htop
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
  libnss3-tools
  libreadline-dev
  libssl-dev
  libtool-bin
  libxml2-dev
  libxslt1-dev
  libyaml-dev
  lm-sensors
  lynx
  make
  maven
  mkcert
  mosh
  ncal
  net-tools
  nfs-common
  openjdk-21-jdk-headless
  opensc
  openssh-server
  pandoc
  parallel
  plocate
  rar
  sed
  silversearcher-ag
  sshpass
  sshuttle
  tcpdump
  tmux
  unrar
  unzip
  uuid
  uuid-dev
  vim
  wget
  whois
  zip
  zlib1g-dev
)

UI_PACKAGES=(
  arandr
  baobab
  cec-utils
  compton
  dconf-editor
  dunst
  ffmpegthumbnailer
  gnome-screenshot
  gnome-software-plugin-flatpak
  gnome-sushi
  gnome-tweaks
  hsetroot
  i3
  i3lock
  i3status
  i3-wm
  lxappearance
  materia-gtk-theme
  network-manager-gnome
  network-manager-openconnect-gnome
  pasystray
  pavucontrol
  rofi
  rxvt-unicode
  scrot
  suckless-tools
  system-config-printer
  texlive-fonts-extra
  thunderbird
  ttf-mscorefonts-installer
  ubuntu-restricted-extras
  viewnior
  virtualbox
  virtualbox-guest-additions-iso
  xclip
  xdg-desktop-portal-gtk
  xmlto
  xsel
  xsettingsd
)

sudo apt-get update -yyq
sudo apt-get install -yyq "${INTERACTIVE_PACKAGES[@]}"

export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -yyq "${CLI_PACKAGES[@]}"

if command -v xrandr &>/dev/null; then
  sudo apt-get install -yyq "${UI_PACKAGES[@]}"
fi

install_docker
install_aws_session_manager

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
