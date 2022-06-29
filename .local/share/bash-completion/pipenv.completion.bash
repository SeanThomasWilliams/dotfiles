#!/bin/bash

if ! command -v pipenv &> /dev/null; then
  return
fi

[[ -x "$(which pipenv)" ]] && eval "$(pipenv --completion)"
