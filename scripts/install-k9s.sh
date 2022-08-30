#!/bin/bash -eu

K9S_VERSION="v0.25.21"

cleanup(){
  rm -rf "${TMP_DIR}"
}

mkdir -p "$HOME/bin"

TMP_DIR=$(mktemp -d)

trap cleanup EXIT

cd "$TMP_DIR"

curl -fSsL "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz" \
  -o k9s.tar.gz
tar -xf k9s.tar.gz
mv k9s "$HOME/bin"
chmod +x "$HOME/bin/k9s"

"$HOME/bin/k9s" version
