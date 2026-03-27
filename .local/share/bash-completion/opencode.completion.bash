#!/usr/bin/env bash
# shellcheck disable=SC2317

# opencode completion - uses built-in yargs completions

if ! command -v opencode &>/dev/null; then
  return 2>/dev/null || exit 0
fi

eval "$(opencode completion)"
