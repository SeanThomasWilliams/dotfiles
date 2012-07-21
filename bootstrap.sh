#!/usr/bin/env sh

for file in `echo .*`; do
    file=$(basename $file)
    ln -s $PWD/$file $HOME/$file
done

# Install janus for vim
if [ ! -d "$HOME/.vim/janus" ]; then
    curl -Lo- https://bit.ly/janus-bootstrap | bash
fi

if [ ! -d "$HOME/.bash_it" ]; then
    git clone http://github.com/revans/bash-it.git ~/.bash_it
    $HOME/.bash_it/install.sh
    echo "Edit ~/.bash_profiile"
fi
