#!/bin/bash

source "$HOME/.asdf/asdf.sh"

export MAKEFLAGS=-j10

PLUGIN_LIST=(
  cmake

  awscli
  ctop
  delta
  flux2
  fzf
  golang
  helm
  istioctl
  jq
  k3d
  k9s
  kafkactl
  kcctl
  kubectl
  kubectx
  kustomize
  minio
  nodejs
  packer
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

asdf install nodejs 16.19.0

asdf plugin add kpt
asdf install kpt v1.0.0-beta.24
asdf global kpt v1.0.0-beta.24
