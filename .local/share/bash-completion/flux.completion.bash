#!/usr/bin/env bash

# flux completion

if command -v flux &>/dev/null
then
  eval "$(flux completion bash)"
fi
