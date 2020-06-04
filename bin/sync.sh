#!/bin/bash -ex

SAFE_OPTS=(--max-delete 0)
REMOTE="drive:work"
LOCAL="$HOME/sync"
RCLONE_VERSION="v1.52.0"
UNAME_S=$(uname -s | tr '[:upper:]' '[:lower:]')

ARCH=""
case $(uname -m) in
  i386) ARCH="386" ;;
  i686) ARCH="386" ;;
  x86_64) ARCH="amd64" ;;
esac

mkdir -p "$LOCAL"

init(){
  export PATH="$HOME/bin:$PATH"

  if ! command -v rclone &> /dev/null; then
    echo >&2 "Installing rclone..."
    TMP_DIR=$(mktemp -d)
    RCLONE_VERSION="rclone-${RCLONE_VERSION}-${UNAME_S}-${ARCH}"
    ZIP_FILE="${RCLONE_VERSION}.zip"
    curl --fail -s -L "https://downloads.rclone.org/${RCLONE_VERSION}/${ZIP_FILE}" -o "$TMP_DIR/$ZIP_FILE"
    unzip -p "$TMP_DIR/$ZIP_FILE" "$RCLONE_VERSION/rclone" > "$HOME/bin/rclone"
    chmod +x "$HOME/bin/rclone"
    rm -rf "$TMP_DIR"
  fi
}

safesync(){
    syncpush
    syncpull
}

syncpush(){
    rclone sync "${SAFE_OPTS[@]}" --update --verbose "$LOCAL" "$REMOTE"
}

syncpull(){
    rclone sync "${SAFE_OPTS[@]}" --update --verbose "$REMOTE" "$LOCAL"
}

while getopts ":f:" opt; do
  case ${opt} in
    f)
      SAFE_OPTS=()
      case "$OPTARG" in
        push)
          syncpush
          exit
          ;;
        pull)
          syncpull
          exit
          ;;
        *)
          echo >&2 "Error: Unknown -f '$OPTARG'"
          exit 1
          ;;
      esac
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

init
safesync
