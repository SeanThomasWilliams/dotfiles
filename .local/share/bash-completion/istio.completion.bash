#!/usr/bin/env bash

# istioctl completion

if command -v istioctl &>/dev/null; then
  eval "$(istioctl completion bash)"
fi
