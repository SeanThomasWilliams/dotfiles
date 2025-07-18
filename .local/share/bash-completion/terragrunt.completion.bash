#!/usr/bin/env bash

# terragrunt completion

if command -v terragrunt &>/dev/null; then
  complete -A directory -W "$(terragrunt | grep -A40 COMMANDS | awk '/^   [a-z]{2,}/ {print prefix$1}; /^GLOBAL OPTIONS/ {prefix="--"}' | xargs)" terragrunt
fi
