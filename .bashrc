#!/bin/bash

# .bashrc -> .bash_profile -> .local.bash_profile
[ -f ~/.bash_profile ] && source ~/.bash_profile

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -r /home/williamss/.bash-eternal-history-fzf.bash ] && source /home/williamss/.bash-eternal-history-fzf.bash

# CUDA environment for non-login interactive shells.
if [ -r /etc/profile.d/cuda.sh ]; then
    . /etc/profile.d/cuda.sh
fi
