#!/usr/bin/env bash

# .bashrc -> .bash_profile -> .alias -> .local.alias

# Exit if non-interactive
[[ -z "$PS1" ]] && return

# Handle the rest in a custom .alias file
if [[ -f "$HOME/.alias" ]]; then
  source "$HOME/.alias"
fi
