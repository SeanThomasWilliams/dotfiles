#!/usr/bin/env bash

# kustomize (Kubernetes kustomize CLI) completion

if command -v kustomize &>/dev/null; then
  eval "$(kustomize completion bash)"
fi
