#!/usr/bin/env bash

export EDITOR="/usr/bin/vim"
export GIT_EDITOR='/usr/bin/vim'

unset MAILCHECK # Don't check mail when opening terminal.

PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\$\[\033[00m\] "

if [ -f ~/.alias ]; then
    . ~/.alias
fi
