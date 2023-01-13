#!/bin/bash

yarn_packages=(
  bash-language-server 
  diagnostic-languageserver 
  dockerfile-language-server-nodejs 
  eslint
  jshint
  lua-fmt 
  markdownlint 
  neovim
  prettier 
  prettier-plugin-toml 
  pyright 
  tern
  typescript 
  typescript-language-server 
)

npm install -g -f yarn
yarn global add --force --non-interactive "${yarn_packages[@]}"

pip install --upgrade cmake-language-server

go install golang.org/x/tools/gopls@latest
