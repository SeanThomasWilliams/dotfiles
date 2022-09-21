#!/bin/bash

set -eux

mkdir -p ~/software
cd ~/software

curl -fSsL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
rm -rf ./aws
unzip awscliv2.zip

sudo ./aws/install --bin-dir /usr/bin/

rm -f "awscliv2.zip"
rm -rf ./aws
