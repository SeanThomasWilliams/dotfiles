#!/usr/bin/env bash
# shellcheck disable=SC1090

# .bash_profile -> .alias -> .local.alias

# Exit if non-interactive
[[ -z "$PS1" ]] && return

[ -f ~/.alias ] && source ~/.alias
