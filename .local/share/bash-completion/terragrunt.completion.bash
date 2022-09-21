#!/usr/bin/env bash

# terragrunt completion

if command -v terragrunt &>/dev/null; then
  complete -W "$(terragrunt | grep -A123 "COMMANDS" | head -n-7 | grep '^   ' | awk '{ print $1 }' | grep -v '*' | xargs)" terragrunt tg
fi
