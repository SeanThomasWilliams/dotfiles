#!/bin/bash

if [[ -d $HOME/anaconda3 ]]; then
    source $HOME/anaconda3/bin/activate
fi

pip install awscli boto boto3 botocore pyopenssl ansible==2.4.3 awslogs netaddr setuptools ansible-lint \
    yamllint pre-commit

pip install --upgrade pip
