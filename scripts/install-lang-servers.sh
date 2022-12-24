#!/bin/bash

npm install -g -f \
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

go install golang.org/x/tools/gopls@latest
