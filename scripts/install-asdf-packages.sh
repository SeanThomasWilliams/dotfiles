#!/bin/bash

source "$HOME/.asdf/asdf.sh"

touch "$HOME/.tool-versions"

export MAKEFLAGS=-j10

PLUGIN_LIST=(
  awscli
  flux2
  golang
  helm
  istioctl
  k3d
  k9s
  kubectl
  kubectx
  kubelogin
  kustomize
  nodejs
  packer
  ruby
  shellcheck
  sops
  terraform
  terraform-ls
  terragrunt
  tflint
  yarn
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

asdf plugin add kpt
asdf install kpt v1.0.0-beta.24
asdf global kpt v1.0.0-beta.24
