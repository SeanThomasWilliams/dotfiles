#!/bin/bash

# Add the HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
# Add the official HashiCorp Linux repository
sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

sudo apt-get update && sudo apt-get install terraform-ls clangd

sudo npm install -g \
  bash-language-server \
  typescript-language-server \
  bash-language-server \
  dockerfile-language-server-nodejs

pip install jedi-language-server
