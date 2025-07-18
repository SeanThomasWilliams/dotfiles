#!/usr/bin/env bash

# zoxide completion

if command -v zoxide &>/dev/null
then
  eval "$(zoxide init bash)"
fi
