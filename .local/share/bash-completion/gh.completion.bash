#!/usr/bin/env bash

# gh completion

if command -v gh &>/dev/null
then
  eval "$(gh completion -s bash)"
fi
