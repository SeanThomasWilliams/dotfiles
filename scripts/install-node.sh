#!/bin/bash

set -euo pipefail

mkdir -p ~/software/nvm/
cd ~/software/nvm/
curl -O https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh

chmod +x install.sh

./install.sh

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install --lts

nvm use --lts
