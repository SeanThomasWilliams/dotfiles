#!/bin/bash

set -euo pipefail

apt_get() {
  sudo -n env DEBIAN_FRONTEND=noninteractive apt-get "$@"
}

install_packages() {
  local package candidate
  local available=()
  for package in "$@"; do
    candidate=$(apt-cache policy "$package" | awk '/Candidate:/ {print $2; exit}')
    if [[ -n "$candidate" && "$candidate" != '(none)' ]]; then
      available+=("$package")
    else
      printf 'Skipping unavailable apt package: %s\n' "$package" >&2
    fi
  done
  if ((${#available[@]})); then
    apt_get install -yyq "${available[@]}"
  fi
}

install_nvidia_drivers() {
  if command -v nvidia-smi &>/dev/null; then
    echo >&2 "Nvidia drivers already installed"
    return 0
  fi

  if lspci | grep -i nvidia >/dev/null; then
    echo >&2 "Nvidia card detected; using Ubuntu driver packages"
    install_packages ubuntu-drivers-common "linux-headers-$(uname -r)" nvidia-cuda-toolkit nvidia-container-runtime
    sudo -n env DEBIAN_FRONTEND=noninteractive ubuntu-drivers install
  else
    echo >&2 "Skipping Nvidia packages: no Nvidia device"
  fi
}

install_docker() {
  if command -v docker &>/dev/null && docker --version >/dev/null; then
    echo >&2 "Keeping the installed Docker"
    return 0
  fi
  install_packages docker.io docker-buildx docker-compose-v2
}

install_aws_session_manager() {
  if command -v session-manager-plugin &>/dev/null; then
    echo >&2 "AWS Session Manager Plugin already installed"
    return 0
  fi

  curl -fSsL -O "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb"
  apt_get install -yyq ./session-manager-plugin.deb
  rm -f ./session-manager-plugin.deb
}

configure_wezterm_repo() {
  local keyring="/usr/share/keyrings/wezterm-fury.gpg"
  if command -v wezterm &>/dev/null; then
    echo >&2 "Wezterm already installed"
    return 0
  fi

  if [[ ! -s "$keyring" ]]; then
    sudo -n install -m 0755 -d /usr/share/keyrings
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo -n gpg --yes --dearmor -o "$keyring"
    sudo -n chmod 644 "$keyring"
  fi
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo -n tee /etc/apt/sources.list.d/wezterm.list >/dev/null
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
  binutils
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
  gh
  git
  glab
  gnupg
  golang-go
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
  libncurses-dev
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
  neovim
  net-tools
  nfs-common
  nodejs
  npm
  openjdk-21-jdk-headless
  opensc
  openssh-server
  pandoc
  parallel
  pciutils
  pkg-config
  plocate
  python3
  python3-venv
  python-is-python3
  rar
  ruby
  ruby-dev
  sed
  shc
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

echo >&2 "Configuring the declared Wezterm repository"
configure_wezterm_repo

echo >&2 "Updating package lists..."
apt_get update -yyq

# Do not change an existing mail configuration on repeat.
if ! dpkg-query -W -f='${db:Status-Status}' postfix 2>/dev/null | grep -qx installed; then
  printf 'postfix postfix/main_mailer_type select No configuration\n' | sudo -n debconf-set-selections
fi
install_packages "${INTERACTIVE_PACKAGES[@]}"

echo >&2 "Installing CLI packages"
install_packages "${CLI_PACKAGES[@]}"
install_docker
install_nvidia_drivers

echo >&2 "Installing UI packages"
if command -v gnome-shell &>/dev/null || command -v xrandr &>/dev/null; then
  install_packages "${UI_PACKAGES[@]}"
else
  echo >&2 "Skipping UI packages: no installed desktop"
fi

echo >&2 "Installing single packages"
install_aws_session_manager

echo >&2 "Done; no automatic package removal"
