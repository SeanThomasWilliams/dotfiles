#!/usr/bin/env bash

# asdf completion

if command -v asdf &>/dev/null; then
  if asdf completion bash &> /dev/null; then
    eval "$(asdf completion bash)"
  fi
fi
