#!/usr/bin/env bash

# crane completion

if command -v crane &>/dev/null
then
  eval "$(crane completion bash)"
fi
