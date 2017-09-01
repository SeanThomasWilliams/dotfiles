#!/bin/bash

set -e

mkdir -p $HOME/software/
cd $HOME/software

GODL="https://storage.googleapis.com/golang/go1.9.linux-amd64.tar.gz"

wget $GODL -O go.tar.gz
tar -xvf go.tar.gz
