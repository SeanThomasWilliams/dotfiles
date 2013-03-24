#!/bin/bash

for file in `echo .*`; do
    file=$(basename $file)
    if [[ ! -e "$HOME/$file" ]]; then
        ln -s $PWD/$file $HOME/$file
    fi
done

gover="go1.0.3.linux-amd64"

wget -N https://go.googlecode.com/files/$gover.tar.gz
if [[ ! -d "~/go" ]]; then
    tar -xvf $gover.tar.gz -C ~/
fi

ln -sf `pwd`/vimrc ~/.vimrc
ln -sf `pwd`/vim ~/.vim

git submodule init
git submodule update
