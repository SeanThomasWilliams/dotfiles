#!/bin/bash

source "$HOME/.asdf/asdf.sh"

PLUGIN_LIST=(
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
  kcat
  kcctl
  kpt
  kubectx
  kustomize
  make
  minio
  neovim
  nodejs
  packer
  popeye
  postgres
  ripgrep
  ruby
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
  echo >&2 "Adding $plugin"
  asdf plugin add "$plugin"
  asdf install "$plugin" latest
  asdf global "$plugin" latest
done
