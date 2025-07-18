#!/usr/bin/env bash

# kind completion

if command -v kind &>/dev/null
then
  eval "$(kind completion bash)"
fi
