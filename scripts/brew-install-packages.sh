#!/bin/bash -eu

install_brew(){
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

command -v brew || install_brew

cat <<EOF | xargs brew install
ag
autojump
bash-completion@2
coreutils
cowsay
direnv
fortune
gcc
htop
jq
kubectl
npm
open-completion
pip-completion
prettier
task
terraform
tflint
tmux
watch
wget
yarn
EOF
