#!/usr/bin/env bash

if [[ -f "$HOME/.local.alias" ]]; then
  source "$HOME/.local.alias"
fi

# Pattern: <class>,<vendor>,<product>,<version>,<allow>
# Use -1 for class/vendor/product/version to accept any value.
#  idVendor           0x04e6 SCM Microsystems, Inc.
#  idProduct          0x5116 SCR331-LC1 / SCR3310 SmartCard Reader
#  idProduct          0x581d SCR3500 C Contact Reader

USB_FILTER="-1,0x04e6,0x5116,-1,1|-1,0x04e6,0x581d,-1,1" # Smartcard Readers

# Take SPICE_VM_HOST from environment variable or default to localhost
SPICE_VM_HOST="${SPICE_VM_HOST:-localhost}"

# Disable pcscd socket and service
sudo systemctl stop pcscd.socket
sudo systemctl stop pcscd
sudo snap disconnect firefox:pcscd

remote-viewer \
  --spice-usbredir-auto-redirect-filter="$USB_FILTER" \
  --spice-usbredir-redirect-on-connect="$USB_FILTER" \
  "spice://${SPICE_VM_HOST}:5900"
