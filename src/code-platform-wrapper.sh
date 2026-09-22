#!/bin/bash

set -euo pipefail

CLI_NAME="$(basename "$0")"

case "$CLI_NAME" in
  gh)
    readonly_roots='^(agent-task|alias|api|attestation|auth|browse|cache|codespace|completion|config|extension|gist|gpg-key|help|issue|label|org|pr|preview|project|release|repo|ruleset|run|search|secret|ssh-key|status|variable|workflow)$'
    write_pattern='^(agent-task create|auth (login|logout|refresh|switch)|cache delete|codespace (code|cp|create|delete|edit|jupyter|rebuild|ssh|stop)|codespace ports visibility|extension exec|gist (create|delete|edit|rename)|gpg-key (add|delete)|issue (close|comment|create|delete|develop|edit|lock|pin|reopen|transfer|unlock|unpin)|label (clone|create|delete|edit)|pr (close|comment|create|edit|lock|merge|ready|reopen|review|unlock|update-branch)|project (close|copy|create|delete|edit|field-create|field-delete|item-add|item-archive|item-create|item-delete|item-edit|link|mark-template|unlink)|release (create|delete|delete-asset|edit|upload)|repo (archive|create|delete|edit|fork|rename|sync|unarchive)|repo autolink (create|delete)|repo deploy-key (add|delete)|run (cancel|delete|rerun)|secret (delete|set)|ssh-key (add|delete)|variable (delete|set)|workflow (disable|enable|run))($| )'
    ;;
  glab)
    readonly_roots='^(alias|api|attestation|auth|changelog|check-update|ci|cluster|completion|config|deploy-key|duo|gpg-key|help|incident|issue|iteration|job|label|mcp|milestone|mr|opentofu|orbit|release|repo|runner|runner-controller|schedule|search|securefile|skills|snippet|ssh-key|stack|todo|token|user|variable|version|work-items)$'
    write_pattern='^(auth (login|logout)|changelog generate|ci (cancel|delete|retry|run|run-trig|trigger)|cluster agent (bootstrap|get-token)|cluster agent token revoke|deploy-key (add|delete)|gpg-key (add|delete)|incident (close|note|reopen|subscribe|unsubscribe)|issue (close|create|delete|note|reopen|subscribe|unsubscribe|update)|issue board create|label (create|delete|edit)|mcp serve|milestone (create|delete|edit)|mr (approve|close|create|delete|merge|note|rebase|reopen|revoke|subscribe|todo|unsubscribe|update)|opentofu state (delete|lock|unlock)|release (create|delete|upload)|repo (archive|create|delete|fork|mirror|publish|transfer|update)|runner (assign|delete|unassign|update)|runner-controller (create|delete|scope|update)|runner-controller token (create|revoke|rotate)|schedule (create|delete|run|update)|securefile (create|remove)|snippet create|ssh-key (add|delete)|stack sync|todo done|token (create|revoke|rotate)|variable (delete|set|update)|work-items (create|delete))($| )'
    ;;
  *)
    echo "Unsupported command name: $CLI_NAME" >&2
    exit 127
    ;;
esac

find_real_cli() {
  local dir candidate
  local -a path_dirs
  local IFS=:

  read -r -a path_dirs <<< "${PATH:-}"
  for dir in "${path_dirs[@]}"; do
    [[ -n "$dir" ]] || dir=.
    candidate="$dir/$CLI_NAME"
    if [[ -x "$candidate" && ! "$candidate" -ef "$0" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

deny() {
  echo "$CLI_NAME: You must obtain explicit permission to perform code platform modifications." >&2
  exit 1
}

api_modifies_remote() {
  local method="" has_fields=0 has_input=0 has_external_field=0 method_override=0 arg value
  local graphql=0
  local -a args=("$@")
  local i

  for ((i = 0; i < ${#args[@]}; i++)); do
    arg="${args[i]}"
    case "$arg" in
      graphql) graphql=1 ;;
      -X|--method)
        if ((i + 1 < ${#args[@]})); then
          method="${args[i + 1]}"
          ((i += 1))
        fi
        ;;
      -X?*) method="${arg#-X}" ;;
      --method=*) method="${arg#*=}" ;;
      -f|-F|--field|--raw-field|--form)
        has_fields=1
        if ((i + 1 < ${#args[@]})); then
          value="${args[i + 1]}"
          [[ "$value" == *@* ]] && has_external_field=1
          ((i += 1))
        fi
        ;;
      -f?*|-F?*|--field=*|--raw-field=*|--form=*)
        has_fields=1
        value="${arg#*=}"
        [[ "$value" == *@* ]] && has_external_field=1
        ;;
      --input)
        has_input=1
        ((i + 1 < ${#args[@]})) && ((i += 1))
        ;;
      --input=*) has_input=1 ;;
      -H|--header)
        if ((i + 1 < ${#args[@]})); then
          value="${args[i + 1],,}"
          [[ "$value" == *x-http-method-override* ]] && method_override=1
          ((i += 1))
        fi
        ;;
      -H?*|--header=*)
        value="${arg,,}"
        [[ "$value" == *x-http-method-override* ]] && method_override=1
        ;;
    esac
  done

  [[ "$method_override" -eq 1 ]] && return 0
  method="${method^^}"
  if [[ -n "$method" && "$method" != "GET" && "$method" != "HEAD" ]]; then
    [[ "$graphql" -eq 1 && "$method" == "POST" ]] || return 0
  fi
  if [[ "$graphql" -eq 1 ]]; then
    [[ "$has_input" -eq 1 || "$has_external_field" -eq 1 ]] && return 0
    [[ " $* " =~ (^|[^[:alnum:]_])mutation([^[:alnum:]_]|$) ]]
    return
  fi
  if [[ "$method" == "GET" || "$method" == "HEAD" ]]; then
    return 1
  fi
  [[ "$has_fields" -eq 1 || "$has_input" -eq 1 ]]
}

REAL_CLI="$(find_real_cli || true)"
if [[ -z "$REAL_CLI" ]]; then
  echo "$CLI_NAME: unable to locate the underlying $CLI_NAME executable" >&2
  exit 127
fi

if [[ "${REPO_WRITE_AUTHORIZED:-}" == "1" ]]; then
  exec "$REAL_CLI" "$@"
fi

words=()
skip_next=0
for arg in "$@"; do
  if [[ "$skip_next" -eq 1 ]]; then
    skip_next=0
    continue
  fi
  case "$arg" in
    -R|--repo|--hostname) skip_next=1 ;;
    -R?*|--repo=*|--hostname=*|-h|--help|-v|--version) ;;
    -*) ;;
    *) words+=("$arg") ;;
  esac
  [[ "${#words[@]}" -ge 4 ]] && break
done

command_path="${words[*]:-}"
if [[ -n "${words[0]:-}" && ! "${words[0]}" =~ $readonly_roots ]]; then
  deny
fi
if [[ "$command_path" =~ $write_pattern ]]; then
  deny
fi
if [[ "${words[0]:-}" == "api" ]] && api_modifies_remote "$@"; then
  deny
fi

exec "$REAL_CLI" "$@"
