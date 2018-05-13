#!/bin/bash

set -eu

SAFE_OPTS="--max-delete 0"
REMOTE="drive:work"
LOCAL="$HOME/sync"

safesync(){
    syncpush
    syncpull
}

syncpush(){
    rclone sync $SAFE_OPTS --update --verbose $LOCAL $REMOTE
}

syncpull(){
    rclone sync $SAFE_OPTS --update --verbose $REMOTE $LOCAL
}

while getopts ":f:" opt; do
    case ${opt} in
        f)
            SAFE_OPTS=""
            if [[ $OPTARG == "push" ]]; then
                syncpush
                exit
            elif [[ $OPTARG == "pull" ]]; then
                syncpull
                exit
            else
                echo "Error $OPTARG"
                exit
            fi
            ;;
        \?)
            echo "Invalid option: $OPTARG" 1>&2
            ;;
        :)
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            ;;
    esac
done
shift $((OPTIND -1))

safesync
