#!/bin/bash

# .bashrc -> .bash_profile -> .local.bash_profile
[ -f ~/.bash_profile ] && source ~/.bash_profile

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
