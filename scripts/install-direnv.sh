#!/bin/bash

set -euo pipefail

export DIRENV_GITHUB_API_TOKEN="$GITHUB_API_TOKEN"
export bin_path="$HOME/bin"

curl -sfL https://direnv.net/install.sh | bash
