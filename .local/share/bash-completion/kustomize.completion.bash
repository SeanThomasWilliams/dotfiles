#!/usr/bin/env bash

# kustomize (Kubernetes kustomize CLI) completion

if command -v kustomize &> /dev/null; then
  complete -C "$(command -v kustomize)" kustomize
fi
