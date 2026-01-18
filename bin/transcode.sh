#!/usr/bin/env bash
#shellcheck disable=SC2086

# Use ffmpeg to transcode a video file to a standard format which works with most devices.

set -eEuo pipefail
umask 0000

if [[ ${DEBUG:-0} -eq 1 ]]; then
  set -x
fi

# Variables
archive_source=0
gpu_index=0
gpu_node=0
log_level=info
video_codec_args=()
source_args=()
subtitle_args=(-c:s copy)
muxer_args=()

trap 'rm -f "$tmp_file"' ERR

dlog(){
  if [[ ${DEBUG:-0} -eq 1 ]]; then
    echo >&2 "$@"
  fi
}

usage(){
  cat >&2 <<EOF
Usage: $0 [-t] [-g] [-i <gpu_index>] <input_file>

Options:
  -f
    Force transcode even if already transcoded
  -g
    Enable GPU mode
  -i <gpu_index>
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

while getopts ":fghi:nt" opt; do
  case "$opt" in
    f)
      force_transcode=1
      ;;
    g)
      gpu_node=1
      ;;
    i)
      gpu_index="$OPTARG"
      ;;
    n)
      dry_run=1
      ;;
    t)
      touch_only=1
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
input_file="$1"
ext="${input_file##*.}"

if [[ $ext = "avi" ]]; then
  ext="mp4"
fi

output_file="${input_file%.*}.${ext}"
archive_file="${input_file}.archive"
tmp_file="${input_file%.*}.$$.tmp.${ext}"
log_file="${input_file%.*}.$$.log"

dlog "Input file: $input_file"
dlog "Output file: $output_file"
dlog "Archive file: $archive_file"
dlog "Temp file: $tmp_file"
dlog "Log file: $log_file"

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

calculate_bitrate(){
  local fname
  fname="$1"

  ffprobe -v quiet -select_streams v:0 -show_entries format=bit_rate -of csv "$fname" |\
    awk -F, '! /N\/A/ {print int($2/1000)}'
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

if [[ "$input_file" =~ .*\.tmp\.*$ ]]; then
  echo >&2 "File: $input_file is a tmp file. Removing and Skipping..."
  rm -f "$input_file"
  exit 0
fi

if [[ ${force_transcode:-0} -eq 1 ]]; then
  echo >&2 "Force mode enabled. Will transcode regardless of previous transcode status."
elif is_transcoded "$input_file"; then
  dlog "File: $input_file is already transcoded. Skipping..."
  exit 0
fi

if [[ ${touch_only:-0} -eq 1 ]]; then
  echo >&2 "Touching file: $input_file"
  touch "$input_file"
  exit 0
fi

file_bitrate=$(calculate_bitrate "$input_file")
if [[ -z "${file_bitrate-}" ]]; then
  echo >&2 "Unable to determine bitrate for file: $input_file"
  exit 1
fi

if [[ $file_bitrate -lt 1000 ]]; then
  bitrate=1000
elif [[ $file_bitrate -gt 2500 ]]; then
  bitrate=2500
else
  bitrate="$file_bitrate"
fi

echo >&2 "Input file '$input_file' has bitrate: '$file_bitrate'. Setting transcode bitrate to: '$bitrate'"
# Calculate max bitrate
max_rate=$((bitrate * 3))

# Get pixel format
pix_fmt="$(extract_pix_fmt "$input_file")"
if [[ -z "$pix_fmt" ]]; then
  echo >&2 "Unable to determine pixel format for file: $input_file"
  exit 1
fi

case "${pix_fmt}" in
  yuv420p|yuvj420p|yuvj444p)
    video_encoding=x264
    ;;
  yuv420p10le)
    video_encoding=x265
    ;;
  *)
    echo >&2 "Invalid pixel format '$pix_fmt' for file: $input_file"
    exit 1
    ;;
esac

if [[ $gpu_node -eq 1 ]]; then
  echo >&2 "GPU-${gpu_index} Transcoding: '$input_file'"
  source_args=(-hwaccel_device "${gpu_index}" -hwaccel cuda)
  if [[ $video_encoding == "x264" ]]; then
    video_codec_args=(-pix_fmt yuv420p -c:v h264_nvenc -profile:v high)
  else
    video_codec_args=(-pix_fmt p010le -c:v hevc_nvenc)
  fi
  video_codec_args+=(-rc-lookahead 20 -preset p6 -metadata composer="transcode.sh GPU")
  # export CUDA_DEVICE_MAX_CONNECTIONS=2
else
  echo >&2 "CPU Transcoding: '$input_file'"
  source_args=(-hwaccel none)
  if [[ $video_encoding == "x264" ]]; then
    video_codec_args=(-pix_fmt yuv420p -c:v libx264 -profile:v high -preset slow)
  else
    video_codec_args=(-pix_fmt yuv420p10le -c:v libx265 -preset slow)
  fi
  video_codec_args+=(-metadata composer="transcode.sh CPU")
fi

if [[ $ext = "mp4" ]]; then
  subtitle_args=(-c:s mov_text)
  muxer_args=(-movflags +faststart)
fi

# If this is a dry run, only transcode the first 10 seconds
if [[ ${dry_run:-0} -eq 1 ]]; then
  source_args+=(-t 10)
fi

nice -n 10 \
  ffmpeg \
    -y \
    -v "$log_level" \
    -hide_banner \
    -stats_period 10s \
    -probesize 100M \
    -analyzeduration 250M \
    -vsync 0 \
    "${source_args[@]}" \
    -threads 0 \
    -i "$input_file" \
    "${video_codec_args[@]}" \
    -b:v "${bitrate}k" \
    -bufsize "${max_rate}k" \
    -maxrate "${max_rate}k" \
    -ac 2 \
    -b:a 128k \
    -c:a aac \
    -map 0:v:0 \
    -map 0:a \
    -map 0:s? \
    -map_metadata 0 \
    -map_chapters 0 \
    "${subtitle_args[@]}" \
    "${muxer_args[@]}" \
    -max_muxing_queue_size 9999 \
    -metadata copyright="$(basename "$input_file")" \
    "$tmp_file" 2>&1 | tee -a "$log_file"

if [[ -f "$tmp_file" ]]; then
  if [[ $(stat -c %s "$tmp_file") -eq 0 ]]; then
    echo >&2 "File: $tmp_file is empty. Removing..."
    rm -fv "$tmp_file"
    exit 1
  else
    # Success Case
    if [[ ${dry_run:-0} -eq 1 ]]; then
      echo >&2 "Dry run. Not moving files."
      exit 0
    fi

    if [[ ${archive_source:-0} -eq 1 ]]; then
      mv -v "$input_file" "$archive_file"
    else
      rm -f "$input_file"
    fi

    mv -v "$tmp_file" "$output_file"
    rm -f "$log_file"
  fi
else
  echo >&2 "File: $tmp_file does not exist. Exiting..."
  exit 1
fi
