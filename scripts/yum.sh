#!/bin/bash

if command -v amazon-linux-extras >/dev/null; then
	amazon-linux-extras enable epel
	sudo yum -y install htop dstat
fi

sudo yum groups install -y Development\ tools
sudo yum install -y \
  autoconf \
  autojump \
  automake \
  curl \
  gcc \
  gcc-c++ \
  gettext \
  icu \
  libtool \
  libuuid-devel \
  libyaml \
  libyaml-devel \
  make \
  mlocate \
  ncurses \
  ncurses-devel \
  ncurses-libs \
  openssl-devel \
  openssl-libs \
  patch \
  pkgconfig \
  readline-devel \
  tmux \
  unzip \
  uuid
