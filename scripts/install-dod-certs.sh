#!/usr/bin/env bash

set -eu
set -o pipefail
set -x

CERT_BUNDLE="unclass-certificates_pkcs7_DoD" \
CERT_URL_PREFIX="https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip" \
CERT_ZIP="/tmp/certs.zip"

trap 'rm -f $CERT_ZIP' EXIT

# Download cert zip
curl -fSsL "${CERT_URL_PREFIX}/${CERT_BUNDLE}.zip" --output "$CERT_ZIP"

source /etc/os-release

unzip -l "$CERT_ZIP"
if [[ $ID == "amzn" || $ID == "rhel" || $ID == "centos" ]]; then
# Extract cert zip and write to ca-trust
  unzip -p "$CERT_ZIP" '*DoD.der.p7b' |\
    sudo openssl pkcs7 -inform der -print_certs -out "/etc/pki/ca-trust/source/anchors/${CERT_BUNDLE}.pem"
  sudo update-ca-trust
elif [[ $ID == "ubuntu" ]]; then
  # Extract cert zip and write individual certs
  cd /usr/local/share/ca-certificates
  unzip -p "$CERT_ZIP" '*DoD.der.p7b' |\
    openssl pkcs7 -print_certs -inform der -out - |\
    sudo awk '/BEGIN CERT/,/END CERT/{ if(/BEGIN CERT/){c++}; out="dod.ca." c ".crt"; print >out}'
  sudo update-ca-certificates
fi
