#!/usr/bin/env bash

# Load RVM, if you are using it
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Add rvm gems and nginx to the path
#export PATH=$PATH:~/.gem/ruby/1.8/bin:/opt/nginx/sbin

# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='envy'
# envy
# pete
# candy

# base.theme.bash bobby candy clean colors.theme.bash demula dos doubletime 
# doubletime_multiline doubletime_multiline_pyonly envy hawaii50 mbriggs 
# minimal modern modern-t n0qorg pete rainbowbrite rjorgenson simple sirup 
# standard tonka tylenol zitron zork

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@github.com'

# Set my editor and git editor
export EDITOR="/usr/bin/vim"
export GIT_EDITOR='/usr/bin/vim'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.

export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli

export TODO="t"

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
source $BASH_IT/bash_it.sh
export NODE_PATH=/usr/local/lib/jsctags/:$NODE_PATH
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell
shopt -u promptvars
export HISTSIZE=500000
export HISTFILESIZE=600000
complete -d cd
set -o vi
[[ -s $HOME/.alias ]] && source $HOME/.alias
PROMPT_COMMAND="$PROMPT_COMMAND"$'\nhistory -a; history -n'

HOSTNAME=`uname -n`
if [ "$TERM" = "xterm" ]
then
   ilabel () { /bin/echo "]1;$*"; }
   label ()  { /bin/echo "]2;$*"; }
   alias stripe='label $HOSTNAME - ${PWD#$HOME/}'
   alias stripe2='label $HOSTNAME - vi $*'
   cds () {
     if [ -z "$1" ]
     then
         "cd"
     else
         "cd" $*
     fi
     eval stripe;
   }
   vis () { eval stripe2; "vi" $*; eval stripe; }
   alias cd=cds
   alias vi=vis
   eval stripe
   eval ilabel "$HOSTNAME"
fi

clear

