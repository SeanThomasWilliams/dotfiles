#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ARCH=$(uname -s | tr '[:upper:]' '[:lower:]')
scversion="stable"
SC_TARBALL="shellcheck-${scversion}.${ARCH}.x86_64.tar.xz"

cleanup(){
  rm -rf shellcheck-*
}

trap cleanup EXIT

cd "$DIR"
curl -fSsL "https://github.com/koalaman/shellcheck/releases/download/stable/$SC_TARBALL" > "$SC_TARBALL"
tar -xvf "$SC_TARBALL"
cp shellcheck-"${scversion}"/shellcheck "$HOME/bin/"
shellcheck --version
