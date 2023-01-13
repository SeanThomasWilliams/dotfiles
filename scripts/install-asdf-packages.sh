#!/bin/bash

source "$HOME/.asdf/asdf.sh"

export MAKEFLAGS=-j10

PLUGIN_LIST=(
  make
  cmake

  awscli
  ctop
  flux2
  fzf
  golang
  helm
  istioctl
  jq
  k3d
  k9s
  kafka
  kafkactl
  kcctl
  kpt
  kubectx
  kustomize
  minio
  packer
  popeye
  ripgrep
  ruby
  shellcheck
  snyk
  sops
  sqlite
  syft
  terraform
  terraform-ls
  terragrunt
  tflint
  tmux
  yarn
  yq
)

asdf plugin add nodejs
asdf install nodejs 16.19.0
asdf global nodejs 16.19.0

for plugin in "${PLUGIN_LIST[@]}"; do
  if [[ -f "$HOME/.asdf/shims/$plugin" ]]; then
    echo >&2 "Plugin $plugin already installed"
    asdf global "$plugin" latest
    continue
  fi

  echo >&2 "Adding $plugin"
  asdf plugin add "$plugin"
  asdf global "$plugin" latest
  asdf install "$plugin" latest
  hash -r
  command -v "$plugin"
done
