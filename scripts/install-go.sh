#!/bin/bash -eux

GO_VERSION="1.18.3"
UNAME_S=$(uname -s | tr '[:upper:]' '[:lower:]')

mkdir -p "$HOME/software"
rm -rf "$HOME/software/go.bak" "$HOME/software/go.tar.gz"
if [[ -d "$HOME/software/go" ]]; then
  mv "$HOME"/software/go{,.bak}
fi

cd "$HOME/software"
curl -fSsL "https://dl.google.com/go/go${GO_VERSION}.${UNAME_S}-amd64.tar.gz" -o go.tar.gz
tar -xvf go.tar.gz
