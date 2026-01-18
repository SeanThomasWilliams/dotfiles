#!/usr/bin/env bash
set -euo pipefail

VERBOSE=0
if [[ "${1:-}" == "--verbose" ]]; then
  VERBOSE=1
fi

# Go to repo root
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

# File list (tracked + a few common extras), with excludes
tmpfile="$(mktemp)"
find . -maxdepth 3 -type f -size +100c \( -name '*.md' -o -name '*.adoc' \) 2>/dev/null > "$tmpfile"
git ls-files -z \
  ':!:*.min.*' ':!:*.map' ':!:*.pyc' ':!:*.crt' ':!:*.rpm' ':!:*.woff' ':!:*.woff2' ':!:*.ttf' |
  tr -d '\r' | tr '\0' '\n' >> "$tmpfile"

sort -u "$tmpfile" > .ctags.files
rm -f "$tmpfile"

# Build tags (NO --languages flag; let mappings and parsers decide)
CTAGS_ARGS=(
  -f .tags.tmp
  --tag-relative=yes
  --sort=yes
  --fields=+ailmnS
  --extras=+q
  --links=no
  --options="$HOME/.ctags.d/project.ctags"
  --exclude='**/*.crt'
  --exclude='**/*.gz'
  --exclude='**/*.key'
  --exclude='**/*.map'
  --exclude='**/*.min.*'
  --exclude='**/*.pcm'
  --exclude='**/*.pem'
  --exclude='**/*.pyc'
  --exclude='**/*.rpm'
  --exclude='**/*.tar'
  --exclude='**/*.tgz'
  --exclude='**/*.ttf'
  --exclude='**/*.wav'
  --exclude='**/*.woff'
  --exclude='**/*.woff2'
  --exclude='**/build/**'
  --exclude='**/cache/**'
  --exclude='**/dist/**'
  --exclude='**/node_modules/**'
  --exclude='**/output/**'
  --exclude='**/vendor/**'
  --exclude='**/vim/**'
  --exclude='.cache'
  --exclude='.direnv'
  --exclude='.git'
  --exclude='.venv'
  -L .ctags.files
)

if [[ $VERBOSE -eq 1 ]]; then
  echo "+ ctags ${CTAGS_ARGS[*]}"
  ctags "${CTAGS_ARGS[@]}" --verbose
else
  ctags "${CTAGS_ARGS[@]}" 2>/dev/null
fi

if ctags --help 2>/dev/null | grep -q -- '--output-format'; then
  ctags -f - "${COMMON_ARGS[@]}" -L .ctags.files --output-format=json > .tags.json 2>/dev/null || true
fi

mv .tags.tmp .tags
echo "Updated .tags ($(wc -l < .tags) entries)"
