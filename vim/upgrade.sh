#!/usr/bin/env bash
set -ex

mkdir -p "$HOME"/.local/bin

system_type=$(uname -s)
if [ "$system_type" = "Darwin" ]; then
  brew install shellcheck
  brew install shfmt
  brew install llvm
  fd 'clangd$' /usr/local/ --exec ln -s '{}' "$HOME"/.local/bin | :

  curl -L https://github.com/rust-analyzer/rust-analyzer/releases/download/nightly/rust-analyzer-mac.gz | gunzip -f >"$HOME"/.local/bin/rust-analyzer && chmod +x "$HOME"/.local/bin/rust-analyzer

else
  sudo dnf install -y \
    ShellCheck \
    clang-tools-extra \
    ;

  curl -L https://github.com/rust-analyzer/rust-analyzer/releases/download/nightly/rust-analyzer-linux.gz | gunzip -f >"$HOME"/.local/bin/rust-analyzer && chmod +x "$HOME"/.local/bin/rust-analyzer
fi

sudo npm install -g -f \
  bash-language-server \
  diagnostic-languageserver \
  dockerfile-language-server-nodejs \
  lua-fmt \
  markdownlint \
  prettier \
  prettier-plugin-toml \
  pyright \
  typescript typescript-language-server \
  ;

pip install --upgrade \
  cmake-language-server \
  ;

GO111MODULE=on go get golang.org/x/tools/gopls@latest
