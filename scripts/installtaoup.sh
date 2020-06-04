#!/bin/bash -eux

mkdir -p "$HOME/software"
cd "$HOME/software"

sudo apt install -y fortune ruby
sudo gem install ansi
rm -rf taoup
git clone https://github.com/globalcitizen/taoup
cd taoup
./taoup --fortune >taoup-fortunes
