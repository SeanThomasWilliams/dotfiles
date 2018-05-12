#!/bin/bash

rclone sync \
    --verbose \
    --max-delete 0 \
    --update \
    $HOME/sync \
    drive:work

rclone sync \
    --verbose \
    --max-delete 0 \
    --update \
    drive:work \
    $HOME/sync
