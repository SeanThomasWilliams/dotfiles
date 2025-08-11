#!/usr/bin/env bash

# glab completion

if command -v glab &>/dev/null
then
  eval "$(glab completion -s bash)"
fi
