#!/bin/bash

set -ex

if [[ -f "$HOME/anaconda3/bin/activate" ]]; then
  source "$HOME/anaconda3/bin/activate"
fi

jupyter notebook --generate-config

jupyter notebook password

echo "c.NotebookApp.ip = '*'" >> "$HOME/.jupyter/jupyter_notebook_config.py"
