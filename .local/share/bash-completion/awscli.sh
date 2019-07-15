#!/bin/bash

# Autocomplete aws
if command -v aws_completer &> /dev/null; then
  complete -C "$(command -v aws_completer)" aws
fi
