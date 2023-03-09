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

if [[ $ID == "amzn" || $ID == "rhel" || $ID == "centos" ]]; then
# Extract cert zip and write to ca-trust
  unzip -p "$CERT_ZIP" '*pem.p7b' |\
    sudo openssl pkcs7 -print_certs -out "/etc/pki/ca-trust/source/anchors/${CERT_BUNDLE}.pem"
  sudo update-ca-trust
elif [[ $ID == "ubuntu" ]]; then
  # Extract cert zip and write individual certs
  cd /usr/local/share/ca-certificates
  unzip -p "$CERT_ZIP" '*pem.p7b' |\
    openssl pkcs7 -print_certs -out - |\
    sudo awk '/BEGIN CERT/,/END CERT/{ if(/BEGIN CERT/){c++}; out="dod.ca." c ".crt"; print >out}'
  sudo update-ca-certificates
fi

if [[ -f "$HOME/anaconda3/ssl/cacert.pem" ]]; then
  # Make a backup of the anaconda3 ssl cert bundle, if it does not exist
  if [[ ! -f "$HOME/anaconda3/ssl/cacert.pem.bak" ]]; then
    cp -v "$HOME/anaconda3/ssl/cacert.pem" "$HOME/anaconda3/ssl/cacert.pem.bak"
  fi

  # Extract cert zip and write to anaconda
  unzip -p "$CERT_ZIP" '*pem.p7b' |\
    openssl pkcs7 -print_certs -out "$HOME/anaconda3/ssl/cacert.dod.pem"

  # Concatenate the anaconda3 ssl cert bundle with the DoD certs
  cat "$HOME/anaconda3/ssl/cacert.pem.bak" \
    "$HOME/anaconda3/ssl/cacert.dod.pem" > "$HOME/anaconda3/ssl/cacert.pem"
fi
