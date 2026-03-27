#!/usr/bin/env bash
# shellcheck disable=SC2207,SC2317

# claude completion

if ! command -v claude &>/dev/null; then
  return 2>/dev/null || exit 0
fi

_claude_completions() {
  local cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  # Top-level subcommands
  local subcommands="agents auth auto-mode doctor install mcp plugin plugins setup-token update upgrade"

  # Top-level options
  local options="
    --add-dir --agent --agents --allow-dangerously-skip-permissions
    --allowedTools --allowed-tools --append-system-prompt --bare --betas
    --brief --chrome --continue --dangerously-skip-permissions --debug
    --debug-file --disable-slash-commands --disallowedTools --disallowed-tools
    --effort --fallback-model --file --fork-session --from-pr --help --ide
    --include-partial-messages --input-format --json-schema --max-budget-usd
    --mcp-config --mcp-debug --model --name --no-chrome
    --no-session-persistence --output-format --permission-mode --plugin-dir
    --print --replay-user-messages --resume --session-id --setting-sources
    --settings --strict-mcp-config --system-prompt --tmux --tools --verbose
    --version --worktree
    -c -d -h -n -p -r -v -w
  "

  # Subcommand-specific completions
  case "${COMP_WORDS[1]}" in
    mcp)
      case "${COMP_WORDS[2]}" in
        add)
          COMPREPLY=($(compgen -W "--transport -e -s --scope --help -h" -- "$cur"))
          return
          ;;
        add-json|remove)
          COMPREPLY=($(compgen -W "--scope -s --help -h" -- "$cur"))
          return
          ;;
        serve)
          COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
          return
          ;;
        *)
          COMPREPLY=($(compgen -W "add add-from-claude-desktop add-json get help list remove reset-project-choices serve" -- "$cur"))
          return
          ;;
      esac
      ;;
    auth)
      COMPREPLY=($(compgen -W "help login logout status" -- "$cur"))
      return
      ;;
    auto-mode)
      COMPREPLY=($(compgen -W "config critique defaults help" -- "$cur"))
      return
      ;;
    plugin|plugins)
      COMPREPLY=($(compgen -W "disable enable help install list marketplace uninstall remove update validate" -- "$cur"))
      return
      ;;
    agents)
      COMPREPLY=($(compgen -W "--setting-sources --help -h" -- "$cur"))
      return
      ;;
    install)
      COMPREPLY=($(compgen -W "--force --help -h stable latest" -- "$cur"))
      return
      ;;
    doctor|setup-token|update|upgrade)
      COMPREPLY=($(compgen -W "--help -h" -- "$cur"))
      return
      ;;
  esac

  # Options that take specific values
  case "$prev" in
    --effort)
      COMPREPLY=($(compgen -W "low medium high max" -- "$cur"))
      return
      ;;
    --model)
      COMPREPLY=($(compgen -W "sonnet opus haiku claude-sonnet-4-6 claude-opus-4-6 claude-haiku-4-5-20251001" -- "$cur"))
      return
      ;;
    --input-format)
      COMPREPLY=($(compgen -W "text stream-json" -- "$cur"))
      return
      ;;
    --output-format)
      COMPREPLY=($(compgen -W "text json stream-json" -- "$cur"))
      return
      ;;
    --permission-mode)
      COMPREPLY=($(compgen -W "acceptEdits bypassPermissions default dontAsk plan auto" -- "$cur"))
      return
      ;;
    --debug-file|--mcp-config|--settings|--plugin-dir)
      COMPREPLY=($(compgen -f -- "$cur"))
      return
      ;;
  esac

  # Default: complete subcommands or options
  if [[ "$cur" == -* ]]; then
    COMPREPLY=($(compgen -W "$options" -- "$cur"))
  elif [[ ${COMP_CWORD} -eq 1 ]]; then
    COMPREPLY=($(compgen -W "$subcommands $options" -- "$cur"))
  fi
}

complete -F _claude_completions claude
