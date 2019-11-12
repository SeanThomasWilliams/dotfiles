#!/bin/bash -eu

install_brew(){
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

command -v brew || install_brew

cat <<EOF | xargs brew install
bash-completion@2
docker-completion
open-completion
pip-completion
ag
autojump
cowsay
coreutils
direnv
fortune
gcc
htop
jq
kubectl
npm
prettier
task
terraform
tflint
tmux
watch
wget
yarn
EOF
