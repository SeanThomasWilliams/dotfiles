#!/bin/bash

# Setup docker in crostini

export DEBIAN_FRONTEND=noninteractive
PACKAGES="
apt-transport-https
ca-certificates
curl
gnupg2
software-properties-common
"

sudo -E apt-get remove -yq docker docker-engine docker.io containerd runc
echo "$PACKAGES" | sudo -E xargs apt-get install -yq
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo -E apt-key add -
sudo -E apt-key fingerprint 0EBFCD88
sudo -E add-apt-repository -y \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"
sudo -E apt-get update -yq
sudo -E apt-get install -yq docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
