#!/bin/bash -eux

pip install --ignore-installed PyYAML \
  awscli \
  boto \
  boto3 \
  botocore \
  pyopenssl \
  awslogs \
  netaddr \
  setuptools \
  ansible-lint \
  yamllint \
  pre-commit \
  docformatter \
  isort \
  yapf \
  pycodestyle \
  flake8

pip install --upgrade pip
