#!/bin/bash

TFLINT_VERSION=v0.11.1
TFLINT_ZIP=tflint_linux_amd64.zip

cleanup(){
  rm -rf $TFLINT_ZIP tflint
}

wget -q https://github.com/wata727/tflint/releases/download/$TFLINT_VERSION/$TFLINT_ZIP
unzip -o $TFLINT_ZIP
install tflint $HOME/bin

cleanup

tflint -v
