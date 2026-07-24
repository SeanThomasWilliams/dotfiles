#!/usr/bin/env bash
# usage: install-tmux.sh [--install-dir DIR]
#
# Installs a pinned static tmux release from tmux/tmux-builds.

set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: install-tmux.sh [--install-dir DIR]

Download, verify, and atomically install the pinned static tmux release.

Options:
  --install-dir DIR  Installation directory (default: $HOME/bin)
  -h, --help         Show this help

Example:
  install-tmux.sh --install-dir "$HOME/bin"
USAGE
}

TMUX_VERSION="3.7b"
RELEASE_BASE_URL="https://github.com/tmux/tmux-builds/releases/download/v${TMUX_VERSION}"
INSTALL_DIR="${HOME:?HOME must be set}/bin"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-dir)
      if [[ $# -lt 2 || -z "$2" ]]; then
        printf 'error: --install-dir requires a directory\n' >&2
        usage >&2
        exit 2
      fi
      INSTALL_DIR="$2"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      printf 'error: unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "$(uname -s)" != "Linux" ]]; then
  printf 'error: this installer supports Linux only\n' >&2
  exit 1
fi

case "$(uname -m)" in
  x86_64)
    ARCH="x86_64"
    SHA256="f85e6c1c412750a774eb3f370f33bad05fc726fb8b6a0b174ad6f0b6d954df58"
    ;;
  aarch64 | arm64)
    ARCH="arm64"
    SHA256="b2955782695283fbc3682a2f77d65616f53b986ee3cf3d80618d3b1cb95b91a6"
    ;;
  *)
    printf 'error: unsupported Linux architecture: %s\n' "$(uname -m)" >&2
    exit 1
    ;;
esac

for command in curl install mktemp sha256sum tar; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'error: required command is unavailable: %s\n' "$command" >&2
    exit 1
  fi
done

ASSET="tmux-${TMUX_VERSION}-linux-${ARCH}.tar.gz"
URL="${RELEASE_BASE_URL}/${ASSET}"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/install-tmux.XXXXXX")"
TEMP_TARGET=""

cleanup() {
  rm -rf "$WORK_DIR"
  if [[ -n "$TEMP_TARGET" ]]; then
    rm -f "$TEMP_TARGET"
  fi
}
trap cleanup EXIT

ARCHIVE="${WORK_DIR}/${ASSET}"
printf 'Downloading %s\n' "$URL"
curl \
  --proto '=https' \
  --tlsv1.2 \
  --fail \
  --location \
  --retry 3 \
  --retry-delay 1 \
  --silent \
  --show-error \
  --output "$ARCHIVE" \
  "$URL"

printf '%s  %s\n' "$SHA256" "$ARCHIVE" | sha256sum --check --status

mapfile -t ARCHIVE_MEMBERS < <(tar -tzf "$ARCHIVE")
if [[ ${#ARCHIVE_MEMBERS[@]} -ne 1 || "${ARCHIVE_MEMBERS[0]#./}" != "tmux" ]]; then
  printf 'error: release archive does not contain exactly one tmux binary\n' >&2
  exit 1
fi

tar -xzf "$ARCHIVE" --directory "$WORK_DIR" --no-same-owner --no-same-permissions
DOWNLOADED_TMUX="${WORK_DIR}/tmux"
if [[ ! -f "$DOWNLOADED_TMUX" || ! -x "$DOWNLOADED_TMUX" ]]; then
  printf 'error: downloaded tmux binary is missing or not executable\n' >&2
  exit 1
fi
if [[ "$($DOWNLOADED_TMUX -V)" != "tmux ${TMUX_VERSION}" ]]; then
  printf 'error: downloaded tmux version does not match %s\n' "$TMUX_VERSION" >&2
  exit 1
fi

mkdir -p "$INSTALL_DIR"
TEMP_TARGET="$(mktemp "${INSTALL_DIR}/.tmux.install.XXXXXX")"
install -m 0755 "$DOWNLOADED_TMUX" "$TEMP_TARGET"
mv -f "$TEMP_TARGET" "${INSTALL_DIR}/tmux"
TEMP_TARGET=""

if [[ "$("${INSTALL_DIR}/tmux" -V)" != "tmux ${TMUX_VERSION}" ]]; then
  printf 'error: installed tmux version verification failed\n' >&2
  exit 1
fi

printf 'Installed tmux %s at %s\n' "$TMUX_VERSION" "${INSTALL_DIR}/tmux"
printf 'Existing tmux servers keep their current version until they are restarted.\n'
