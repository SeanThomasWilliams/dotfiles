#!/bin/bash

for file in `echo .*`; do
    file=$(basename $file)
    if [[ ! -e "$HOME/$file" ]]; then
        ln -s $PWD/$file $HOME/$file
    fi
done

ln -sf `pwd`/vimrc ~/.vimrc
ln -sf `pwd`/vim ~/.vim

git submodule init
git submodule update

bash -c "go get -u github.com/nsf/gocode"
