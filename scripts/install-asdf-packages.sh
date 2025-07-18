#!/bin/bash

set -uo pipefail

if ! command -v asdf &> /dev/null; then
  echo >&2 "Install asdf first!"
  exit 1
fi

touch "$HOME/.tool-versions"

export MAKEFLAGS=-j10

asdf plugin add zoxide https://github.com/nyrst/asdf-zoxide.git

asdf plugin add kpt
asdf install kpt v1.0.0-beta.24
asdf set --home kpt v1.0.0-beta.24

PLUGIN_LIST=(
  awscli
  flux2
  golang
  helm
  istioctl
  k3d
  k9s
  fzf
  kubectl
  kubectx
  kubelogin
  kustomize
  packer
  shellcheck
  sops
  terraform
  terraform-ls
  tflint
  zoxide

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

  asdf set --home "$plugin" latest
  asdf install "$plugin" latest
  hash -r
  command -v "$plugin"
}
export -f install_plugin

echo "${PLUGIN_LIST[@]}" | xargs -n 1 -P 1 bash -c 'install_plugin "$@"' _
