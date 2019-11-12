#!/bin/bash -eux

DIR=$(cd "$(dirname "$0")" && pwd)

pip install --upgrade pip

pip install --ignore-installed PyYAML -r "$DIR/requirements.txt"
