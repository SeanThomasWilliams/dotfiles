#!/usr/bin/env bash
#shellcheck disable=2044

set -eu
set -o pipefail
set -x

CERT_BUNDLE="unclass-certificates_pkcs7_DoD" \
CERT_URL_PREFIX="https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip" \
CERT_ZIP="/tmp/certs.zip"

CERTDB_DIRS=(
  "$HOME/snap/firefox/common/.mozilla"
  "$HOME/.mozilla"
)

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

  for certdb_dir in "${CERTDB_DIRS[@]}"; do
    if [[ -d "$certdb_dir" ]]; then
      for cert_db in $(find  "$certdb_dir" -type f -name "cert9.db"); do
        cert_dir=$(dirname "$cert_db")
        echo >&2 "Updating Cert DB: $cert_db in $cert_dir"
        for certificate_file in $(find /usr/local/share/ca-certificates -type f -name 'dod.ca.*'); do
          echo >&2 "Cert file: $certificate_file"
          certificate_name=$(openssl x509 -in "$certificate_file" -text -noout |\
            grep -o 'Subject:.*' |\
            sed 's#.*CN = \(.*\)#\1#' |\
            tr ' ' '-' |\
            tr '[:upper:]' '[:lower:]')

          echo >&2 "Mozilla Firefox certificate install '${certificate_name}' in ${cert_dir}"
          certutil -A \
            -n "${certificate_name}" \
            -t "TCu,Cuw,Tuw" \
            -i "${certificate_file}" \
            -d sql:"${cert_dir}"
        done
      done
    fi
  done
fi
