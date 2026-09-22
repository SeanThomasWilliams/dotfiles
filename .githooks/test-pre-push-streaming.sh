#!/usr/bin/env bash
# Focused system-shaped checks for pre-push streaming and bounded inspection.
set -euo pipefail

DOTFILES_ROOT="$(git -C "$(dirname "${BASH_SOURCE[0]}")/.." rev-parse --show-toplevel)"
SOURCE_HOOKS="${DOTFILES_ROOT}/.githooks"
RUNTIME_PARENT="${XDG_RUNTIME_DIR:-${HOME}/.cache}"
mkdir -p "${RUNTIME_PARENT}"
SCRATCH="$(mktemp -d "${RUNTIME_PARENT}/dotfiles-pre-push.XXXXXX")"
trap 'rm -rf -- "${SCRATCH}"' EXIT

before_status="${SCRATCH}/dotfiles-status.before"
before_worktree="${SCRATCH}/dotfiles-worktree.before"
before_index="${SCRATCH}/dotfiles-index.before"
before_hashes="${SCRATCH}/source-hashes.before"
git -C "${DOTFILES_ROOT}" status --porcelain=v2 -z >"${before_status}"
git -C "${DOTFILES_ROOT}" diff --binary >"${before_worktree}"
git -C "${DOTFILES_ROOT}" diff --cached --binary >"${before_index}"
sha256sum \
  "${SOURCE_HOOKS}/pre-push" \
  "${SOURCE_HOOKS}/check-blocked-value" \
  "${SOURCE_HOOKS}/blocked-names" \
  "${SOURCE_HOOKS}/blocked-patterns" \
  "${SOURCE_HOOKS}/test-pre-push-streaming.sh" >"${before_hashes}"

FIXTURE_HOOKS="${SCRATCH}/hooks"
EMPTY_HOOKS="${SCRATCH}/empty-hooks"
BIN_DIR="${SCRATCH}/bin"
REPOS_DIR="${SCRATCH}/repos"
mkdir -p "${FIXTURE_HOOKS}" "${EMPTY_HOOKS}" "${BIN_DIR}" "${REPOS_DIR}"
cp -- \
  "${SOURCE_HOOKS}/pre-push" \
  "${SOURCE_HOOKS}/check-blocked-value" \
  "${SOURCE_HOOKS}/blocked-names" \
  "${SOURCE_HOOKS}/blocked-patterns" \
  "${FIXTURE_HOOKS}/"
chmod 755 "${FIXTURE_HOOKS}/pre-push" "${FIXTURE_HOOKS}/check-blocked-value"

cat >"${BIN_DIR}/git-lfs" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\0' "$@" >"${LFS_ARGS_OUT:?}"
cat >"${LFS_STDIN_OUT:?}"
STUB
chmod 755 "${BIN_DIR}/git-lfs"

checks=0
failures=0
pass() {
  checks=$((checks + 1))
  printf 'ok %d - %s\n' "${checks}" "$1"
}
fail() {
  checks=$((checks + 1))
  failures=$((failures + 1))
  printf 'not ok %d - %s\n' "${checks}" "$1" >&2
  if [[ -n "${2:-}" ]]; then
    printf '%s\n' "$2" >&2
  fi
}
assert_status() {
  local expected="$1" label="$2"
  if [[ "${HOOK_STATUS}" -eq "${expected}" ]]; then
    pass "${label}"
  else
    fail "${label} (expected status ${expected}, got ${HOOK_STATUS})" "$(<"${HOOK_OUTPUT}")"
  fi
}
assert_hook_failed() {
  local label="$1"
  if ((HOOK_STATUS != 0)); then
    pass "${label}"
  else
    fail "${label} (hook unexpectedly passed)" "$(<"${HOOK_OUTPUT}")"
  fi
}
assert_output_matches() {
  local pattern="$1" label="$2"
  if grep -Eq -- "${pattern}" "${HOOK_OUTPUT}"; then
    pass "${label}"
  else
    fail "${label} (missing output pattern: ${pattern})" "$(<"${HOOK_OUTPUT}")"
  fi
}
assert_files_equal() {
  local expected="$1" actual="$2" label="$3"
  if [[ -f "${actual}" ]] && cmp -s -- "${expected}" "${actual}"; then
    pass "${label}"
  else
    fail "${label}"
  fi
}

new_repo() {
  local name="$1" repo
  repo="${REPOS_DIR}/${name}"
  git init -q -b main "${repo}"
  git -C "${repo}" config user.name 'Hook Fixture'
  git -C "${repo}" config user.email 'hook-fixture@example.invalid'
  git -C "${repo}" config commit.gpgSign false
  git -C "${repo}" config core.hooksPath "${EMPTY_HOOKS}"
  printf 'base\n' >"${repo}/data.txt"
  git -C "${repo}" add -- data.txt
  git -C "${repo}" commit -q -m 'test: safe baseline'
  printf '%s\n' "${repo}"
}

new_repo_with_disposable() {
  local name="$1" repo
  repo="$(new_repo "${name}")"
  mkdir -p "${repo}/ai_temp" "${repo}/ai_logs"
  printf 'temporary\n' >"${repo}/ai_temp/item"
  printf 'log\n' >"${repo}/ai_logs/item"
  git -C "${repo}" add -f -- ai_temp/item ai_logs/item
  git -C "${repo}" commit -q -m 'test: published disposable files'
  printf '%s\n' "${repo}"
}

new_bare() {
  local name="$1" bare
  bare="${REPOS_DIR}/${name}.git"
  git init -q --bare -b main "${bare}"
  git --git-dir="${bare}" config core.hooksPath "${EMPTY_HOOKS}"
  printf '%s\n' "${bare}"
}

publish_ref() {
  local bare="$1" ref="$2" oid="$3"
  git --git-dir="${bare}" fetch -q "${repo}" '+refs/heads/*:refs/source/*'
  git --git-dir="${bare}" update-ref "${ref}" "${oid}"
}

commit_empty() {
  local repo="$1" message="$2"
  git -C "${repo}" commit -q --allow-empty -m "${message}"
}

commit_file() {
  local repo="$1" path="$2" content="$3" message="$4"
  mkdir -p "$(dirname "${repo}/${path}")"
  printf '%s\n' "${content}" >>"${repo}/${path}"
  git -C "${repo}" add -f -- "${path}"
  git -C "${repo}" commit -q -m "${message}"
}

HOOK_STATUS=0
HOOK_OUTPUT="${SCRATCH}/hook.output"
HOOK_INPUT="${SCRATCH}/hook.input"
LFS_STDIN="${SCRATCH}/lfs.stdin"
LFS_ARGS="${SCRATCH}/lfs.args"
run_hook() {
  local repo="$1" remote_name="$2" remote_location="$3" ref_lines="$4"
  printf '%s' "${ref_lines}" >"${HOOK_INPUT}"
  rm -f -- "${HOOK_OUTPUT}" "${LFS_STDIN}" "${LFS_ARGS}"
  set +e
  (
    cd "${repo}"
    PATH="${BIN_DIR}:${PATH}" \
      LFS_STDIN_OUT="${LFS_STDIN}" \
      LFS_ARGS_OUT="${LFS_ARGS}" \
      "${FIXTURE_HOOKS}/pre-push" "${remote_name}" "${remote_location}" <"${HOOK_INPUT}"
  ) >"${HOOK_OUTPUT}" 2>&1
  HOOK_STATUS=$?
  set -e
}

make_ref_line() {
  local local_ref="$1" local_oid="$2" remote_ref="$3" remote_oid="$4"
  printf '%s %s %s %s\n' "${local_ref}" "${local_oid}" "${remote_ref}" "${remote_oid}"
}

zero_oid=0000000000000000000000000000000000000000

# Streaming input exceeds the operating-system argv ceiling and still matches.
arg_max="$(getconf ARG_MAX)"
stream_output="${SCRATCH}/stream.output"
set +e
{
  head -c "$((arg_max + 1024))" /dev/zero | tr '\0' X
  printf '\ndevin\n'
} | "${FIXTURE_HOOKS}/check-blocked-value" names >"${stream_output}" 2>&1
stream_status=$?
set -e
if [[ ${stream_status} -eq 0 ]] && grep -qx 'devin' "${stream_output}"; then
  pass 'streamed input larger than ARG_MAX matches a blocked token'
else
  fail "streamed input larger than ARG_MAX matches a blocked token (status ${stream_status})" "$(<"${stream_output}")"
fi
set +e
head -c "$((arg_max + 1024))" /dev/zero | tr '\0' X |
  "${FIXTURE_HOOKS}/check-blocked-value" names >"${stream_output}" 2>&1
stream_status=$?
set -e
if [[ ${stream_status} -eq 1 ]]; then
  pass 'streamed safe input larger than ARG_MAX remains allowed'
else
  fail "streamed safe input larger than ARG_MAX remains allowed (status ${stream_status})" "$(<"${stream_output}")"
fi

# Safe push and exact LFS delegation.
repo="$(new_repo safe)"
bare="$(new_bare safe-remote)"
head_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${zero_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_status 0 'safe commit passes pre-push inspection'
assert_files_equal "${HOOK_INPUT}" "${LFS_STDIN}" 'Git LFS receives the original ref input byte-for-byte'
printf '%s\0' pre-push "${bare}" "${bare}" >"${SCRATCH}/expected-lfs.args"
assert_files_equal "${SCRATCH}/expected-lfs.args" "${LFS_ARGS}" 'Git LFS receives the original hook arguments'

# A ref deletion carries no local commits to inspect and must reach LFS intact,
# even when the deleted branch name would be blocked for an update.
repo="$(new_repo deletion-ref)"
bare="$(new_bare deletion-ref-remote)"
base_oid="$(git -C "${repo}" rev-parse HEAD)"
publish_ref "${bare}" refs/heads/devin-old "${base_oid}"
refs="$(make_ref_line refs/heads/devin-old "${zero_oid}" refs/heads/devin-old "${base_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_status 0 'deletion ref bypasses commit and branch gating'
assert_files_equal "${HOOK_INPUT}" "${LFS_STDIN}" 'deletion ref reaches Git LFS byte-for-byte'

# Blocked values in each inspected surface fail.
repo="$(new_repo blocked-message)"
bare="$(new_bare blocked-message-remote)"
base_oid="$(git -C "${repo}" rev-parse HEAD)"
publish_ref "${bare}" refs/heads/main "${base_oid}"
commit_empty "${repo}" 'test: ask devin to update'
head_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${base_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_hook_failed 'blocked commit message fails pre-push inspection'
assert_output_matches 'message matches blocked pattern' 'blocked message failure identifies the message surface'

repo="$(new_repo blocked-path)"
bare="$(new_bare blocked-path-remote)"
base_oid="$(git -C "${repo}" rev-parse HEAD)"
publish_ref "${bare}" refs/heads/main "${base_oid}"
commit_file "${repo}" notes/devin.txt 'safe text' 'test: add safe note'
head_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${base_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_hook_failed 'blocked path fails pre-push inspection'
assert_output_matches 'path .* matches blocked pattern' 'blocked path failure identifies the path surface'

repo="$(new_repo blocked-content)"
bare="$(new_bare blocked-content-remote)"
base_oid="$(git -C "${repo}" rev-parse HEAD)"
publish_ref "${bare}" refs/heads/main "${base_oid}"
commit_file "${repo}" data.txt 'owner: devin' 'test: add safe metadata'
head_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${base_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_hook_failed 'blocked added content fails pre-push inspection'
assert_output_matches 'additions in .* match blocked pattern' 'blocked content failure identifies the additions surface'

# Disposable paths reject additions and modifications but permit cleanup-only deletion.
repo="$(new_repo disposable-add)"
bare="$(new_bare disposable-add-remote)"
base_oid="$(git -C "${repo}" rev-parse HEAD)"
publish_ref "${bare}" refs/heads/main "${base_oid}"
commit_file "${repo}" ai_temp/item 'temporary' 'test: add temporary file'
head_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${base_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_hook_failed 'adding ai_temp content fails pre-push inspection'
assert_output_matches 'may only delete ai_temp and ai_logs paths' 'disposable addition reports deletion-only policy'

repo="$(new_repo_with_disposable disposable-modify)"
bare="$(new_bare disposable-modify-remote)"
base_oid="$(git -C "${repo}" rev-parse HEAD)"
publish_ref "${bare}" refs/heads/main "${base_oid}"
commit_file "${repo}" ai_logs/item 'changed' 'test: modify published log'
head_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${base_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_hook_failed 'modifying ai_logs content fails pre-push inspection'

repo="$(new_repo_with_disposable disposable-delete)"
bare="$(new_bare disposable-delete-remote)"
base_oid="$(git -C "${repo}" rev-parse HEAD)"
publish_ref "${bare}" refs/heads/main "${base_oid}"
git -C "${repo}" rm -q -- ai_temp/item ai_logs/item
git -C "${repo}" commit -q -m 'test: remove disposable files'
head_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${base_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_status 0 'deletion-only ai_temp and ai_logs cleanup passes'

# More than 50 unpublished commits warns and continues on main. A blocked older
# commit outside the newest 50 is intentionally not inspected.
repo="$(new_repo capped-main)"
bare="$(new_bare capped-main-remote)"
base_oid="$(git -C "${repo}" rev-parse HEAD)"
publish_ref "${bare}" refs/heads/main "${base_oid}"
commit_empty "${repo}" 'test: legacy devin marker outside inspection window'
for i in $(seq 1 51); do
  commit_empty "${repo}" "test: safe capped commit ${i}"
done
head_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${base_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_status 0 'main with more than 50 unpublished commits is not gated by count or older commits'
assert_output_matches 'more than 50 unpublished commits; inspected only the newest 50' 'over-limit main push emits the bounded-inspection warning'

# Multiple ref lines are both processed and forwarded exactly.
repo="$(new_repo multi-ref)"
bare="$(new_bare multi-ref-remote)"
base_oid="$(git -C "${repo}" rev-parse HEAD)"
publish_ref "${bare}" refs/heads/main "${base_oid}"
publish_ref "${bare}" refs/heads/feature "${base_oid}"
commit_empty "${repo}" 'test: safe main update'
main_oid="$(git -C "${repo}" rev-parse HEAD)"
git -C "${repo}" switch -q -c feature "${base_oid}"
commit_empty "${repo}" 'test: safe feature update'
feature_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${main_oid}" refs/heads/main "${base_oid}")"$'\n'
refs+="$(make_ref_line refs/heads/feature "${feature_oid}" refs/heads/feature "${base_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_status 0 'two safe ref updates are inspected in one hook invocation'
assert_files_equal "${HOOK_INPUT}" "${LFS_STDIN}" 'multiple ref lines reach Git LFS byte-for-byte'

blocked_refs="$(make_ref_line refs/heads/main "${main_oid}" refs/heads/main "${base_oid}")"$'\n'
blocked_refs+="$(make_ref_line refs/heads/devin-feature "${feature_oid}" refs/heads/devin-feature "${base_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${blocked_refs}"
assert_hook_failed 'a blocked second ref proves all update lines are inspected'
assert_output_matches 'pushed branch .* matches blocked pattern' 'blocked second ref reports the branch surface'

# Successful remote listing subtracts commits reachable from every published ref.
repo="$(new_repo published-subtraction)"
bare="$(new_bare published-subtraction-remote)"
commit_empty "${repo}" 'test: devin marker already published elsewhere'
published_oid="$(git -C "${repo}" rev-parse HEAD)"
publish_ref "${bare}" refs/heads/already-published "${published_oid}"
commit_empty "${repo}" 'test: safe unpublished child'
head_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${zero_oid}")"$'\n'
run_hook "${repo}" "${bare}" "${bare}" "${refs}"
assert_status 0 'published-ref subtraction excludes an already-published blocked commit'

# Failed remote listing preserves both fallback shapes.
repo="$(new_repo fallback-new-ref)"
commit_empty "${repo}" 'test: devin marker on a tracked remote ref'
published_oid="$(git -C "${repo}" rev-parse HEAD)"
git -C "${repo}" update-ref refs/remotes/origin/published "${published_oid}"
commit_empty "${repo}" 'test: safe fallback child'
head_oid="$(git -C "${repo}" rev-parse HEAD)"
missing_remote="${SCRATCH}/missing-remote"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${zero_oid}")"$'\n'
run_hook "${repo}" "${missing_remote}" "${missing_remote}" "${refs}"
assert_status 0 'new-ref fallback subtracts locally known remote-tracking refs'
assert_output_matches 'could not list published refs' 'new-ref fallback warns about unavailable remote listing'

repo="$(new_repo fallback-existing-ref)"
base_oid="$(git -C "${repo}" rev-parse HEAD)"
commit_empty "${repo}" 'test: ask devin during fallback'
head_oid="$(git -C "${repo}" rev-parse HEAD)"
refs="$(make_ref_line refs/heads/main "${head_oid}" refs/heads/main "${base_oid}")"$'\n'
run_hook "${repo}" "${missing_remote}" "${missing_remote}" "${refs}"
assert_hook_failed 'existing-ref fallback inspects the explicit remote-to-local range'
assert_output_matches 'could not list published refs' 'existing-ref fallback warns about unavailable remote listing'
assert_output_matches 'message matches blocked pattern' 'existing-ref fallback still enforces commit policy'

# Source checkout must remain byte-for-byte stable throughout fixture execution.
after_status="${SCRATCH}/dotfiles-status.after"
after_worktree="${SCRATCH}/dotfiles-worktree.after"
after_index="${SCRATCH}/dotfiles-index.after"
after_hashes="${SCRATCH}/source-hashes.after"
git -C "${DOTFILES_ROOT}" status --porcelain=v2 -z >"${after_status}"
git -C "${DOTFILES_ROOT}" diff --binary >"${after_worktree}"
git -C "${DOTFILES_ROOT}" diff --cached --binary >"${after_index}"
sha256sum \
  "${SOURCE_HOOKS}/pre-push" \
  "${SOURCE_HOOKS}/check-blocked-value" \
  "${SOURCE_HOOKS}/blocked-names" \
  "${SOURCE_HOOKS}/blocked-patterns" \
  "${SOURCE_HOOKS}/test-pre-push-streaming.sh" >"${after_hashes}"
assert_files_equal "${before_status}" "${after_status}" 'fixture preserves target checkout status'
assert_files_equal "${before_worktree}" "${after_worktree}" 'fixture preserves target worktree diff'
assert_files_equal "${before_index}" "${after_index}" 'fixture preserves target index diff'
assert_files_equal "${before_hashes}" "${after_hashes}" 'fixture preserves source hook and policy bytes'

if ((failures != 0)); then
  printf 'FAIL: %d of %d pre-push checks failed\n' "${failures}" "${checks}" >&2
  exit 1
fi
printf 'PASS: %d pre-push checks\n' "${checks}"
