#!/usr/bin/env bash

if command -v warp-cli &>/dev/null; then
  if warp-cli status &>/dev/null; then
    eval "$(warp-cli generate-completions bash)"
  fi
fi
