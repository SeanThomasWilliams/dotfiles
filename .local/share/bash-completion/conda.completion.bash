#!/usr/bin/env bash
if ! command -v register-python-argcomplete &> /dev/null; then
    return
fi

which register-python-argcomplete > /dev/null \
  && eval "$(register-python-argcomplete conda)" \
  || echo "Please install argcomplete to use conda completion"
