#!/usr/bin/env bash
#shellcheck disable=SC2086

# Use ffmpeg to transcode a video file to a standard format which works with most devices.

set -eEuo pipefail
umask 0000

if [[ ${DEBUG:-0} -eq 1 ]]; then
  set -x
fi

# Variables
ARCHIVE_SOURCE=0
BITRATE=1500
GPU_INDEX=0
GPU_MODE=0
LOG_LEVEL=info

# Complex variables
MAX_RATE=$((BITRATE * 3))

trap 'rm -f "$TMP_FILE"' ERR

dlog(){
  if [[ ${DEBUG:-0} -eq 1 ]]; then
    echo >&2 "$@"
  fi
}

usage(){
  cat >&2 <<EOF
Usage: $0 [-t] [-g] [-i <GPU_INDEX>] <INPUT_FILE>

Options:
  -g
    Enable GPU mode
  -i <GPU_INDEX>
    Set GPU index
  -n
    Dry run
  -t
    Touch non-transcoded files and exit
  -h
    Show this help message
EOF
}


if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

while getopts ":ghi:nt" opt; do
  case "$opt" in
    g)
      GPU_MODE=1
      ;;
    i)
      GPU_INDEX="$OPTARG"
      ;;
    n)
      DRY_RUN=1
      ;;
    t)
      TOUCH_ONLY=1
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo >&2 "Invalid option: -$OPTARG"
      exit 1
      ;;
    :)
      echo >&2 "Option -$OPTARG requires an argument."
      exit 1
      ;;
  esac
done

shift $((OPTIND - 1))

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

# Process filenames
INPUT_FILE="$1"
EXT="${INPUT_FILE##*.}"

if [[ ${EXT} == "avi" ]]; then
  EXT="mp4"
fi

OUTPUT_FILE="${INPUT_FILE%.*}.${EXT}"
ARCHIVE_FILE="${INPUT_FILE}.archive"
TMP_FILE="${INPUT_FILE%.*}.$$.tmp.${EXT}"
LOG_FILE="${INPUT_FILE%.*}.$$.log"

dlog "Input file: $INPUT_FILE"
dlog "Output file: $OUTPUT_FILE"
dlog "Archive file: $ARCHIVE_FILE"
dlog "Temp file: $TMP_FILE"
dlog "Log file: $LOG_FILE"

is_transcoded(){
  local fname
  fname="$1"

  if ffmpeg -i "$fname" -f ffmetadata - 2> /dev/null |\
    awk -F= 'BEGIN{IGNORECASE=1} /composer/ {print $2}' |\
    grep -q transcode.sh; then
    return 0
  else
    return 1
  fi
}

extract_pix_fmt(){
  local fname
  fname="$1"

  ffmpeg \
    -hide_banner \
    -probesize 100M \
    -analyzeduration 250M \
    -i "$fname" \
    -f ffmetadata \
    -y /dev/null 2>&1 |\
  awk '
    /^Output #/ {valid=0;}
    /^Input #/ {valid=1;}
    /^  Stream.*Video: mjpeg/ {next;}
    valid == 1 && /^  Stream.*Video/ {print $0;}
  ' |\
  sed -e 's/\[[^[]*\]//g' |\
  sed -e 's/([^()]*)//g' |\
  sed -e 's/(.*)//g' |\
  sed -e 's/\s+/ /g' |\
  awk -F, '{gsub(/ /,""); print $2}'
}

if [[ "$INPUT_FILE" =~ .*\.tmp\.*$ ]]; then
  echo >&2 "File: $INPUT_FILE is a tmp file. Removing and Skipping..."
  rm -f "$INPUT_FILE"
  exit 0
fi

if is_transcoded "$INPUT_FILE"; then
  dlog "File: $INPUT_FILE is already transcoded. Skipping..."
  exit 0
else
  if [[ ${TOUCH_ONLY:-0} -eq 1 ]]; then
    echo >&2 "Touching file: $INPUT_FILE"
    touch "$INPUT_FILE"
    exit 0
  fi
fi

# Get pixel format
PIX_FMT="$(extract_pix_fmt "$INPUT_FILE")"
if [[ -z "$PIX_FMT" ]]; then
  echo >&2 "Unable to determine pixel format for file: $INPUT_FILE"
  exit 1
fi

case "${PIX_FMT}" in
  yuv420p|yuvj420p|yuvj444p)
    VIDEO_ENCODING=x264
    ;;
  yuv420p10le)
    VIDEO_ENCODING=x265
    ;;
  *)
    echo >&2 "Invalid pixel format '$PIX_FMT' for file: $INPUT_FILE"
    exit 1
    ;;
esac

if [[ $GPU_MODE -eq 1 ]]; then
  echo >&2 "GPU-${GPU_INDEX} Transcoding: '$INPUT_FILE'"
  SOURCE_ARGS="-hwaccel cuda"
  if [[ $VIDEO_ENCODING == "x264" ]]; then
    VIDEO_ARGS=(-pix_fmt yuv420p -c:v h264_nvenc -profile:v high)
  else
    VIDEO_ARGS=(-pix_fmt p010le -c:v hevc_nvenc)
  fi
  VIDEO_ARGS+=(-preset p6 -metadata composer="transcode.sh GPU")
  export CUDA_VISIBLE_DEVICES="$GPU_INDEX"
  export CUDA_DEVICE_MAX_CONNECTIONS=2
else
  echo >&2 "CPU Transcoding: '$INPUT_FILE'"
  SOURCE_ARGS="-hwaccel none"
  if [[ $VIDEO_ENCODING == "x264" ]]; then
    VIDEO_ARGS=(-pix_fmt yuv420p -c:v libx264 -profile:v high -preset slow)
  else
    VIDEO_ARGS=(-pix_fmt yuv420p10le -c:v libx265 -preset slow)
  fi
  VIDEO_ARGS+=(-metadata composer="transcode.sh CPU")
fi

# If this is a dry run, only transcode the first 10 seconds
if [[ ${DRY_RUN:-0} -eq 1 ]]; then
  SOURCE_ARGS="$SOURCE_ARGS -t 10"
fi

nice -n 10 ffmpeg \
  -y \
  -v "$LOG_LEVEL" \
  -hide_banner \
  -stats_period 10s \
  -probesize 100M \
  -analyzeduration 250M \
  -vsync 0 \
  ${SOURCE_ARGS} \
  -threads 0 \
  -i "$INPUT_FILE" \
  "${VIDEO_ARGS[@]}" \
  -b:v "${BITRATE}k" \
  -bufsize "${MAX_RATE}k" \
  -maxrate "${MAX_RATE}k" \
  -movflags faststart \
  -ac 2 \
  -b:a 128k \
  -c:a aac \
  -map 0:v:0 \
  -map 0:a \
  -max_muxing_queue_size 9999 \
  -metadata copyright="$(basename "$INPUT_FILE")" \
  "$TMP_FILE" 2>&1 | tee -a "$LOG_FILE"

if [[ -f "$TMP_FILE" ]]; then
  if [[ $(stat -c %s "$TMP_FILE") -eq 0 ]]; then
    echo >&2 "File: $TMP_FILE is empty. Removing..."
    rm -fv "$TMP_FILE"
    exit 1
  else
    # Success Case
    if [[ ${DRY_RUN:-0} -eq 1 ]]; then
      echo >&2 "Dry run. Not moving files."
      exit 0
    fi

    if [[ ${ARCHIVE_SOURCE:-0} -eq 1 ]]; then
      mv -v "$INPUT_FILE" "$ARCHIVE_FILE"
    else
      rm -f "$INPUT_FILE"
    fi

    mv -v "$TMP_FILE" "$OUTPUT_FILE"
    rm -f "$LOG_FILE"
  fi
else
  echo >&2 "File: $TMP_FILE does not exist. Exiting..."
  exit 1
fi
