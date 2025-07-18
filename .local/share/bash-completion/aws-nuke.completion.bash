#!/usr/bin/env bash

if command -v aws-nuke &>/dev/null; then
  eval "$(aws-nuke completion bash)"
fi
