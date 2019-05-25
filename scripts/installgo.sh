#!/bin/bash -e

mkdir -p $HOME/software/

GO_VERSION="1.12.4"

GO_DL="https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"

rm -rf "$HOME/software/go.back"
if [[ -d "$HOME/software/go" ]]; then
  mv $HOME/software/go{,.bak}
fi

cd $HOME/software
wget "$GO_DL" -O go.tar.gz
tar -xvf go.tar.gz
