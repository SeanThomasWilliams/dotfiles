#!/bin/bash

set -eu

if grep -q Ubuntu /etc/os-release; then
  sudo add-apt-repository ppa:git-core/ppa
  sudo apt update
  sudo apt install git
  exit
fi

sudo yum -y groupinstall "Development Tools"
sudo yum -y install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel wget libcurl-devel
sudo yum -y remove git

mkdir -p $HOME/software
cd $HOME/software

wget https://github.com/git/git/archive/v2.7.0.tar.gz -O git.tar.gz

tar -xvf git.tar.gz
cd git-*

make configure
./configure --prefix=/usr
make -j
sudo make install

git --version
