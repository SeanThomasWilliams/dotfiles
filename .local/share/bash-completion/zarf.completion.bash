#!/usr/bin/env bash

# zarf completion

if command -v zarf &>/dev/null
then
  eval "$(zarf completion bash --no-log-file)"
fi
