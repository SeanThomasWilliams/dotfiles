#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

INPUT_FILE="${1:-/dev/stdin}"

SAML_RESPONSE=$(cat "$INPUT_FILE")

if echo "$SAML_RESPONSE" | grep -q '%'; then
  echo >&2 "Input is url-encoded. Decoding..."
  SAML_RESPONSE=$(echo "$SAML_RESPONSE" | urldecode)
fi

echo "$SAML_RESPONSE" |\
  base64 --decode |\
  tidy -w 0 -i -xml -q
