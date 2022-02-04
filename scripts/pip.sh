#!/bin/bash

set -ex

pip install --upgrade pip

pip install --ignore-installed PyYAML -r "$DIR/requirements.txt"

hash -r

rm -rf "$HOME/.local/pipx"
pipx install jedi-language-server==0.35.0 --include-deps --force

conda install -c conda-forge pytorch-forecasting pytorch -v -y
conda install -c conda-forge jupyterlab ipykernel -v -y
