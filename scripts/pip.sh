#!/bin/bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pip install --upgrade pip

pip install --ignore-installed PyYAML -r "$DIR/requirements.txt"

hash -r

rm -rf "$HOME/.local/pipx"
pipx install jedi-language-server --include-deps --force

#pipx install docker-compose --include-deps --force

# ML
#conda install -c conda-forge pytorch-forecasting pytorch -v -y
#conda install -c conda-forge jupyterlab ipykernel -v -y
