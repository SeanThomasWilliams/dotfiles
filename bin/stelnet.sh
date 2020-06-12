#!/bin/bash -eux

HOST=$1
PORT=$2
PROTO=${3:-tcp}

(echo > "/dev/$PROTO/$HOST/$PORT") > /dev/null 2>&1 && \
  echo "Target is up!" || \
  echo "Target is down!"
