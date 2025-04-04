#!/bin/bash

if command -v amazon-linux-extras >/dev/null; then
	amazon-linux-extras enable epel
	sudo yum -y install htop dstat
fi

sudo yum groups install -y Development\ tools
sudo yum install -y \
  autoconf \
  automake \
  cmake \
  curl \
  gcc \
  gcc-c++ \
  gettext \
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
  openscap-scanner \
  openscap-utils \
  openssl-devel \
  openssl-libs \
  patch \
  pkgconfig \
  python3 \
  readline-devel \
  tmux \
  unzip \
  uuid \
  xmlto
