#!/bin/bash

set -euo pipefail

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
  packer
  shellcheck
  sops
  terraform
  terraform-ls
  terragrunt
  tflint

  #nodejs
  #ruby
  #yarn
)

install_plugin() {
  local plugin
  plugin="$1"

  cd "$HOME"

  echo >&2 "Adding $plugin"
  if [[ -f "$HOME/.asdf/shims/$plugin" ]]; then
    echo >&2 "Plugin $plugin already installed"
  else
    asdf plugin add "$plugin"
  fi

  asdf global "$plugin" latest
  asdf install "$plugin" latest
  hash -r
  command -v "$plugin"
}
export -f install_plugin

echo "${PLUGIN_LIST[@]}" | xargs -n 1 -P 4 -I {} bash -c 'install_plugin "$@"' _ {}

asdf plugin add kpt
asdf install kpt v1.0.0-beta.24
asdf global kpt v1.0.0-beta.24
