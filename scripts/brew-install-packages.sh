#!/bin/bash -eu

install_brew(){
  echo >&2 "Installing brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

if ! command -v brew &> /dev/null; then
  install_brew
fi

BREW_INSTALLED_PACKAGES="$(brew list)"

brew_install(){
  local package="$1"
  if ! echo "$BREW_INSTALLED_PACKAGES" | grep -q "$package"; then
    brew install "$package"
  else
    echo >&2 "Package $package is already installed"
  fi
}

while read -r pkg; do
  brew_install "$pkg"
done < brew.txt
