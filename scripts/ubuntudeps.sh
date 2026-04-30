#!/bin/bash

set -euo pipefail

install_nvidia_drivers() {
  if command -v nvidia-smi &>/dev/null; then
    echo >&2 "Nvidia drivers already installed"
    return 0
  fi

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
}

install_docker() {
  # Check if Docker is already installed
  local docker_sources_list="/etc/apt/sources.list.d/docker.list"
  if [[ -f "$docker_sources_list" ]]; then
    echo >&2 "Docker already installed"
    return 0
  fi

  # Add Docker's official GPG key:
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  sudo apt-get update -yyq
  sudo apt-get remove -yyq docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
  sudo apt-get install -yyq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

install_aws_session_manager() {
  if command -v session-manager-plugin &>/dev/null; then
    echo >&2 "AWS Session Manager Plugin already installed"
    return 0
  fi

  curl -fSsL -O "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb"
  sudo apt-get install -yyq ./session-manager-plugin.deb
  rm -f ./session-manager-plugin.deb
}

configure_firefox_repo() {
  local moztermppa="/etc/apt/preferences.d/mozillateamppa"
  if [[ -f "$moztermppa" ]]; then
    echo >&2 "Firefox already installed"
    return 0
  fi

  sudo add-apt-repository ppa:mozillateam/ppa -y
  cat <<EOF | sudo tee "$moztermppa"
Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1
EOF
}

configure_wezterm_repo() {
  local keyring="/usr/share/keyrings/wezterm-fury.gpg"
  if [[ -f "$keyring" ]]; then
    echo >&2 "Wezterm already installed"
    return 0
  fi

  sudo install -m 0755 -d /usr/share/keyrings
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o "$keyring"
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null
  sudo chmod 644 "$keyring"
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
  dh-autoreconf
  direnv
  dnsmasq
  dstat
  entr
  ethtool
  feh
  fonts-mplus
  fonts-noto
  fonts-symbola
  fzf
  g++
  gawk
  gcc
  gettext
  git
  gnupg
  gnutls-bin
  grep
  htop
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
  libpam0g-dev
  libreadline-dev
  libssl-dev
  libtool-bin
  libxml2-dev
  libxslt1-dev
  libyaml-dev
  lm-sensors
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
  pkg-config
  plocate
  python3
  rar
  sed
  silversearcher-ag
  sshpass
  sshuttle
  tcpdump
  tmux
  universal-ctags
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

  imagemagick
  libfontconfig1-dev
  libxcb-xfixes0-dev
  libxkbcommon-dev
  wezterm
  firefox
)

echo >&2 "Updating package lists..."

echo >&2 "Configuring repos"
configure_firefox_repo
configure_wezterm_repo
install_docker
install_nvidia_drivers
sudo add-apt-repository ppa:git-core/ppa -y

echo >&2 "Installing interactive packages"
sudo apt-get update -yyq
sudo apt-get install -yyq "${INTERACTIVE_PACKAGES[@]}"

echo >&2 "Installing CLI packages"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -yyq "${CLI_PACKAGES[@]}"

echo >&2 "Installing UI packages"
if command -v xrandr &>/dev/null; then
  sudo apt-get install -yyq "${UI_PACKAGES[@]}"
fi

echo >&2 "Installing single packages"
install_aws_session_manager

echo >&2 "Cleaning up..."

sudo apt autoremove -yyq

echo >&2 "Done"
