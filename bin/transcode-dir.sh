#!/bin/bash
# shellcheck disable=SC2016

# This script will transcode all files in a directory
LOG_FILE=$(date "+/tmp/transcodedir.%Y-%m-%d.%H%M.log")

FIND_ARGS=(
  -mtime -5
)

TRANSCODE_ARGS=()

usage(){
  cat <<EOF
Usage: $(basename "$0") [options] <directory>

Options:
  -a
    Transcode all files in the directory
  -d
    Enable debug mode
  -x
    Use xargs over GNU parallel
  -h
    Show this help message
EOF
}

while getopts ":adhtx" opt; do
  case $opt in
    a)
      FIND_ARGS=()
      ;;
    d)
      set -x
      ;;
    t)
      TRANSCODE_ARGS=("-t")
      ;;
    x)
      USE_XARGS=1
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo >&2 "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [[ $# -lt 1 ]]; then
  echo >&2 "Usage: $0 <directory>"
  exit 1
fi

if [[ ! -d "$1" ]]; then
  echo >&2 "Error: $1 is not a directory"
  exit 1
fi

DIR_NAME=("$@")

find "${DIR_NAME[@]}" -type f -size 0 -print -delete 2>&1 | tee "$LOG_FILE"
find "${DIR_NAME[@]}" -type f \( -name '*.log' -o -name '*.tmp.*' \) -print -delete 2>&1 | tee -a "$LOG_FILE"

# Delete older log files
find /tmp -maxdepth 1 -name 'transcode*.log' -mtime +7 -print -delete

NUM_GPU=$(nvidia-smi -L | wc -l)
NUM_JOBS=$((NUM_GPU*3))

if [[ ${USE_XARGS-} ]]; then
  find "${DIR_NAME[@]}" \
    "${FIND_ARGS[@]}" \
    -type f \( -name '*.mp4' -o -name '*.avi' -o -name '*.mkv' \) -print0 |\
    sort -z |\
    xargs -0 -n1 -P2 \
    transcode.sh \
      "${TRANSCODE_ARGS[@]}" 2>&1 | tee -a "$LOG_FILE"
else
  find "${DIR_NAME[@]}" \
    "${FIND_ARGS[@]}" \
    -type f \( -name '*.mp4' -o -name '*.avi' -o -name '*.mkv' \) -print0 |\
    sort -z |\
    parallel \
    -0 \
    -j${NUM_JOBS} \
    transcode.sh \
      "${TRANSCODE_ARGS[@]}" \
      -g \
      -i "{=\$_=sprintf(\"%d\",(\$job->slot()-1)%${NUM_GPU})=}" "{}" 2>&1 | tee -a "$LOG_FILE"
fi
