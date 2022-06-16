#!/usr/bin/env bash

# k3d completion

if command -v k3d &>/dev/null
then
  eval "$(k3d completion bash)"
fi
