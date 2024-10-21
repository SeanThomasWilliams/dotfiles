#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_brew(){
  echo >&2 "Installing brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

if ! command -v brew &> /dev/null; then
  install_brew
fi

BREW_INSTALLED_PACKAGES="$(brew list)"

brew_install(){
  local package="$1"
  if ! echo "$BREW_INSTALLED_PACKAGES" | grep -q "$package"; then
    echo >&2 "Installing $package"
    brew install "$package"
  else
    echo >&2 "Package $package is already installed"
  fi
}

INSTALL_PACKAGES=$(cat "$SCRIPT_DIR/brew.txt")

for pkg in ${INSTALL_PACKAGES}; do
  brew_install "$pkg"
done
