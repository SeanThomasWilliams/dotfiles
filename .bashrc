#!/bin/bash

# .bashrc -> .bash_profile -> .alias -> .local.alias

[ -f ~/.bash_profile ] && source ~/.bash_profile

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
