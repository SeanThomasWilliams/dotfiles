#!/bin/bash

for file in `echo .*`; do
    file=$(basename $file)
    if [[ ! -e "$HOME/$file" ]]; then
        ln -s $PWD/$file $HOME/$file
    fi
done

gover="go1.0.3.linux-amd64"

if [[ ! -e "$HOME/go" ]]; then
    mkdir -p install
    cd install
    wget -N "https://go.googlecode.com/files/$gover.tar.gz"
    tar -xvf $gover.tar.gz -C ~/
    cd -
fi

ln -sf `pwd`/vimrc ~/.vimrc
ln -sf `pwd`/vim ~/.vim

git submodule init
git submodule update

bash -c "go get -u github.com/nsf/gocode"
bash -c "go get -u github.com/vmihailenco/redis"

