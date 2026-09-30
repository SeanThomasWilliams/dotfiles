#!/usr/bin/env bash
# shellcheck disable=SC1090

# .bash_profile -> .profile, then .alias -> .local.alias for interactive shells.
[ -f "$HOME/.profile" ] && . "$HOME/.profile"

# Exit if non-interactive
[[ -z "$PS1" ]] && return

[ -f ~/.alias ] && source ~/.alias
