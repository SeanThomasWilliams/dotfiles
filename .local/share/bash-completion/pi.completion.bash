#!/usr/bin/env bash
# shellcheck disable=SC2207,SC2317

# pi completion

if ! command -v pi &>/dev/null; then
  return 2>/dev/null || exit 0
fi

_pi_completions() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  # Subcommands
  local subcommands="install remove uninstall update list config"

  # Top-level options
  local options="
    --provider --model --api-key --system-prompt --append-system-prompt
    --mode --print --continue --resume --session --fork --session-dir
    --no-session --models --no-tools --tools --thinking --extension
    --no-extensions --skill --no-skills --prompt-template
    --no-prompt-templates --theme --no-themes --export --list-models
    --verbose --offline --help --version
    -p -c -r -e -ne -ns -np -h -v
  "

  case "${COMP_WORDS[1]}" in
    install|remove|uninstall)
      COMPREPLY=($(compgen -W "--help -l" -- "$cur"))
      return
      ;;
    update)
      COMPREPLY=($(compgen -W "--help" -- "$cur"))
      return
      ;;
    list|config)
      COMPREPLY=($(compgen -W "--help" -- "$cur"))
      return
      ;;
  esac

  case "$prev" in
    --provider)
      COMPREPLY=($(compgen -W "anthropic google openai azure groq cerebras xai openrouter mistral minimax bedrock" -- "$cur"))
      return
      ;;
    --mode)
      COMPREPLY=($(compgen -W "text json rpc" -- "$cur"))
      return
      ;;
    --thinking)
      COMPREPLY=($(compgen -W "off minimal low medium high xhigh" -- "$cur"))
      return
      ;;
    --tools)
      COMPREPLY=($(compgen -W "read bash edit write grep find ls" -- "$cur"))
      return
      ;;
    --model|--api-key|--system-prompt|--append-system-prompt|--session|--fork|--session-dir|--models|--export|--extension|--skill|--prompt-template|--theme)
      # These take a value, fall back to file completion
      COMPREPLY=($(compgen -f -- "$cur"))
      return
      ;;
  esac

  if [[ "$cur" == -* ]]; then
    COMPREPLY=($(compgen -W "$options" -- "$cur"))
  elif [[ ${COMP_CWORD} -eq 1 ]]; then
    COMPREPLY=($(compgen -W "$subcommands $options" -- "$cur"))
  fi
}

complete -F _pi_completions pi
