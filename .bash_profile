#!/usr/bin/env bash

# Exit if non-interactive
[[ -z "$PS1" ]] && return

unset MAILCHECK # Don't check mail when opening terminal.

PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]:(\[\033[01;34m\] \")\$\[\033[00m\] "

# Handle the rest in a custom .alias file
if [ -f ~/.alias ]; then
  source ~/.alias
fi

"$HOME"/software/taoup/taoup-fortune
