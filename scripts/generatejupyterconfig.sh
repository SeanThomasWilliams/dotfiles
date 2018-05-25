#!/bin/bash

set -ex

if [[ -d $HOME/anaconda3 ]]; then
    source $HOME/anaconda3/bin/activate
fi

jupyter notebook --generate-config

jupyter notebook password

echo "c.NotebookApp.ip = '*'" >> $HOME/.jupyter/jupyter_notebook_config.py
