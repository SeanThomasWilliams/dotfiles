#!/usr/bin/env bash
#shellcheck disable=SC2207

# Makefile target completion with caching based on md5

_make_completions(){
  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  local use_cache suggestions
  use_cache=0

  MAKEFILE="$PWD/Makefile"
  MAKEFILE_MD5="$PWD/.Makefile.md5sum"
  MAKEFILE_CACHE="$PWD/.Makefile.cache"

  if [[ ! -f "$MAKEFILE" ]]; then
    return
  fi

  # Check if we should use the cache
  if [[ -f "$MAKEFILE_MD5" && -f "$MAKEFILE_CACHE" ]]; then
    if md5sum -c "$MAKEFILE_MD5" &> /dev/null; then
      use_cache=1
    fi
  fi

  # Populate the cache
  if [[ $use_cache -eq 0 ]]; then
    #echo >&2 -e "\nRepopulating cache..."

    make -qp |\
      grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' |\
      sed 's/[^a-zA-Z0-9_-]*$//;/^\./d;/Makefile/d;/FORCE/d' |\
      sort -u > "$MAKEFILE_CACHE"

    # Make new md5
    md5sum "$MAKEFILE" > "$MAKEFILE_MD5"
  fi

  # keep the suggestions in a local variable
  suggestions=($(compgen -W "$(cat "$MAKEFILE_CACHE")" -- "${COMP_WORDS[1]}"))

  if [ "${#suggestions[@]}" == "1" ]; then
    # if there's only one match, we remove the command literal
    # to proceed with the automatic completion of the number
    COMPREPLY=("${suggestions[0]}")
  else
    # more than one suggestions resolved,
    # respond with the suggestions intact
    COMPREPLY=("${suggestions[@]}")
  fi
}

complete -F _make_completions make
complete -F _make_completions remake
