#!/bin/bash

mkdir -p "$HOME/software" "$HOME/bin"
cd "$HOME/software"

curl -fsSL --connect-timeout 10 "https://releases.hashicorp.com/packer/1.8.3/packer_1.8.3_linux_amd64.zip" \
        -o packer.zip
unzip -o -q packer.zip
mv packer ~/bin/packer
rm -f packer.zip
chmod +x ~/bin/packer
