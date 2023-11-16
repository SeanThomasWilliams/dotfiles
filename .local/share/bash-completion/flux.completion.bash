#!/usr/bin/env bash

if command -v flux &>/dev/null; then
  eval "$(flux completion bash)"
fi
