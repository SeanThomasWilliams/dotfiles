#!/bin/bash

set -e

mkdir -p $HOME/software/
cd $HOME/software

GODL="https://dl.google.com/go/go1.10.linux-amd64.tar.gz"

wget $GODL -O go.tar.gz
tar -xvf go.tar.gz
