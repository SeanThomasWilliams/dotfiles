#!/bin/bash

set -euo pipefail
set -x

OPENSC_MODULES=(
  /usr/lib/opensc-pkcs11.so
  /usr/lib/pkcs11/opensc-pkcs11.so
  /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so
)
CAC_MODULE_NAME="CAC Module"

for MODULE_PATH in "${OPENSC_MODULES[@]}"; do
  if [ -f "$MODULE_PATH" ]; then
    break
  fi
done

if modutil -dbdir sql:"$HOME/.pki/nssdb/" -list "$CAC_MODULE_NAME" &>/dev/null; then
  echo >&2 "Removing existing CAC module"
  modutil -dbdir sql:"$HOME/.pki/nssdb/" -delete "$CAC_MODULE_NAME" -force
fi

modutil -dbdir sql:"$HOME/.pki/nssdb/" -add "CAC Module" -libfile "$MODULE_PATH" -force
modutil -dbdir sql:"$HOME/.pki/nssdb/" -list
