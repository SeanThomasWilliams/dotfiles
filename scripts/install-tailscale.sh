#!/bin/bash

set -eux

curl -fsSL https://tailscale.com/install.sh | sh

sudo tailscale up --accept-dns
