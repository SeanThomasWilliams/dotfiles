#!/usr/bin/env bash

set -eu
set -o pipefail

CERT_BUNDLE="certificates_pkcs7_DoD" \
CERT_URL_PREFIX="https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip" \
CERT_ZIP="/tmp/certs.zip"

trap 'rm -f $CERT_ZIP' EXIT

# Download cert zip
curl -s "${CERT_URL_PREFIX}/${CERT_BUNDLE}.zip" --output "$CERT_ZIP"

cd /usr/local/share/ca-certificates

# Extract cert zip and write individual certs
unzip -p "$CERT_ZIP" '*.pem.p7b' |\
  openssl pkcs7 -print_certs -out - |\
  sudo awk '/BEGIN CERT/,/END CERT/{ if(/BEGIN CERT/){c++}; out="dod.ca." c ".pem"; print >out}'

sudo update-ca-certificates
