#!/usr/bin/env bash
#shellcheck disable=SC2086

set -eEuo pipefail
umask 0000

# Use ffmpeg to transcode a video file to a standard format which works with most devices.
if [[ $# -lt 1 ]]; then
  echo >&2 "Usage: $0 <INPUT_FILE>"
  exit 1
fi

if [[ ${DEBUG:-0} -eq 1 ]]; then
  set -x
fi

ARCHIVE_FILE=0
LOG_LEVEL=info

# Process filenames
INPUT_FILE="$1"
EXT="${INPUT_FILE##*.}"

if [[ ${EXT} == "avi" ]]; then
  EXT="mp4"
fi

ARCHIVE_FILE="${INPUT_FILE}.archive"
TMP_FILE="${INPUT_FILE%.*}.$$.tmp.${EXT}"
OUTPUT_FILE="${INPUT_FILE%.*}.${EXT}"

is_transcoded(){
  local fname
  fname="$1"

  ffprobe_out=$(ffprobe "$fname" 2>&1)

  if echo "$ffprobe_out" |\
    awk 'BEGIN{IGNORECASE=1} /composer/ {print $3}' |\
    grep -q transcode.sh; then
    return 0
  else
    return 1
  fi
}

if is_transcoded "$INPUT_FILE"; then
  echo >&2 "File: $INPUT_FILE is already transcoded. Skipping..."
  exit 0
fi

trap 'rm -f "$TMP_FILE"' ERR

ffmpeg \
  -y \
  -v "$LOG_LEVEL" \
  -i "$INPUT_FILE" \
  -metadata composer="transcode.sh" \
  -metadata copyright="$(basename "$INPUT_FILE")" \
  -codec copy \
  "$TMP_FILE"

if [[ -f "$TMP_FILE" ]]; then
  if [[ $(stat -c %s "$TMP_FILE") -eq 0 ]]; then
    echo >&2 "File: $TMP_FILE is empty!"
    exit 1
  else
    mv -v "$INPUT_FILE" "$ARCHIVE_FILE"
    mv -v "$TMP_FILE" "$OUTPUT_FILE"
  fi
else
  echo >&2 "File: $TMP_FILE does not exist. Exiting..."
  exit 1
fi
