#!/bin/bash

if command -v amazon-linux-extras >/dev/null; then
	amazon-linux-extras enable epel
	sudo yum -y install htop dstat
fi

sudo yum groups install -y --allowerasing Development\ tools
sudo yum install --allowerasing -y \
  autoconf \
  automake \
  cmake \
  curl \
  fuse3 \
  gcc \
  gcc-c++ \
  gettext \
  gnupg2 \
  golang \
  icu \
  libtool \
  libuuid-devel \
  libyaml \
  libyaml-devel \
  lynx \
  make \
  mlocate \
  ncurses \
  ncurses-devel \
  ncurses-libs \
  nodejs20-npm \
  openscap-scanner \
  openscap-utils \
  openssl-devel \
  openssl-libs \
  patch \
  pkgconfig \
  python3 \
  readline-devel \
  ruby \
  ruby-devel \
  tmux \
  unzip \
  uuid \
  xmlto
