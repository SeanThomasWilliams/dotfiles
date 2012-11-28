#!/bin/bash

for file in `echo .*`; do
    file=$(basename $file)
    ln -s $PWD/$file $HOME/$file
done

ln -sf `pwd`/vimrc ~/.vimrc
ln -sf `pwd`/vim ~/.vim

git submodule init
git submodule update
