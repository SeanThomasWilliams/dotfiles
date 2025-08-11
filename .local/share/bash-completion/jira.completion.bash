#!/bin/bash

if command -v jira &> /dev/null; then
  eval "$(jira completion bash)"
fi
