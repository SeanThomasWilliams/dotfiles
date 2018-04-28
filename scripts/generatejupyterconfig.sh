#!/bin/bash

set -ex

jupyter notebook --generate-config

jupyter notebook password

echo "c.NotebookApp.ip = '*'" >> $HOME/.jupyter/jupyter_notebook_config.py
