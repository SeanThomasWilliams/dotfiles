#!/bin/bash

if ! command -v jira &> /dev/null; then
  return
fi

eval "$(jira --completion-script-bash)"
