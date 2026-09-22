#!/usr/bin/env bash
# Focused regression matrix for the global hook path policy.
set -euo pipefail

DOTFILES_ROOT="$(git -C "$(dirname "${BASH_SOURCE[0]}")/.." rev-parse --show-toplevel)"
SOURCE_HOOKS="${DOTFILES_ROOT}/.githooks"
RUNTIME_PARENT="${XDG_RUNTIME_DIR:-${HOME}/.cache}"
mkdir -p "${RUNTIME_PARENT}"
SCRATCH="$(mktemp -d "${RUNTIME_PARENT}/dotfiles-hook-policy.XXXXXX")"
trap 'rm -rf -- "${SCRATCH}"' EXIT

before_status="${SCRATCH}/dotfiles-status.before"
before_worktree="${SCRATCH}/dotfiles-worktree.before"
before_index="${SCRATCH}/dotfiles-index.before"
before_hashes="${SCRATCH}/hook-hashes.before"
git -C "${DOTFILES_ROOT}" status --porcelain=v2 -z >"${before_status}"
git -C "${DOTFILES_ROOT}" diff --binary >"${before_worktree}"
git -C "${DOTFILES_ROOT}" diff --cached --binary >"${before_index}"
sha256sum \
  "${SOURCE_HOOKS}/pre-commit" \
  "${SOURCE_HOOKS}/commit-msg" \
  "${SOURCE_HOOKS}/check-blocked-value" \
  "${SOURCE_HOOKS}/check-skill-conflicts" \
  "${SOURCE_HOOKS}/blocked-names" \
  "${SOURCE_HOOKS}/blocked-patterns" >"${before_hashes}"

FIXTURE_HOOKS="${SCRATCH}/hooks"
EMPTY_HOOKS="${SCRATCH}/empty-hooks"
mkdir -p "${FIXTURE_HOOKS}" "${EMPTY_HOOKS}"
cp -- \
  "${SOURCE_HOOKS}/pre-commit" \
  "${SOURCE_HOOKS}/commit-msg" \
  "${SOURCE_HOOKS}/check-blocked-value" \
  "${SOURCE_HOOKS}/check-skill-conflicts" \
  "${SOURCE_HOOKS}/blocked-names" \
  "${SOURCE_HOOKS}/blocked-patterns" \
  "${FIXTURE_HOOKS}/"
chmod 700 \
  "${FIXTURE_HOOKS}/pre-commit" \
  "${FIXTURE_HOOKS}/commit-msg" \
  "${FIXTURE_HOOKS}/check-blocked-value" \
  "${FIXTURE_HOOKS}/check-skill-conflicts"

init_repo() {
  local repo="$1" include_root_agents="$2"
  mkdir -p "${repo}"
  git -C "${repo}" init -q -b main
  git -C "${repo}" config user.name 'Hook Fixture'
  git -C "${repo}" config user.email 'hook-fixture@example.invalid'
  git -C "${repo}" config core.hooksPath "${EMPTY_HOOKS}"
  git -C "${repo}" remote add origin https://github.com/xeedio/hook-fixture.git

  mkdir -p \
    "${repo}/existing" \
    "${repo}/nested" \
    "${repo}/.claude" \
    "${repo}/sub/.pi" \
    "${repo}/ai_temp" \
    "${repo}/ai_logs" \
    "${repo}/ai_issues" \
    "${repo}/ai_tests" \
    "${repo}/ai_docs" \
    "${repo}/ai_wiki" \
    "${repo}/ai_scripts" \
    "${repo}/.agents/skills/example/work"
  printf 'fixture\n' >"${repo}/README.md"
  if [[ "${include_root_agents}" == true ]]; then
    printf 'root instructions\n' >"${repo}/AGENTS.md"
  fi
  printf 'existing instructions\n' >"${repo}/existing/AGENTS.md"
  printf 'existing sub instructions\n' >"${repo}/existing/SUBAGENTS.md"
  printf 'private override\n' >"${repo}/existing/AGENTS.override.md"
  printf 'legacy instructions\n' >"${repo}/CLAUDE.md"
  printf 'nested legacy instructions\n' >"${repo}/nested/CLAUDE.local.md"
  printf 'other legacy instructions\n' >"${repo}/nested/CLAUDE.extra"
  printf '{}\n' >"${repo}/.claude/settings.json"
  printf 'state\n' >"${repo}/sub/.pi/state"
  printf 'temporary\n' >"${repo}/ai_temp/item"
  printf 'log\n' >"${repo}/ai_logs/item"
  printf 'issue\n' >"${repo}/ai_issues/item"
  printf 'test\n' >"${repo}/ai_tests/item"
  printf 'doc\n' >"${repo}/ai_docs/item"
  printf 'wiki\n' >"${repo}/ai_wiki/index.md"
  printf '#!/bin/sh\n' >"${repo}/ai_scripts/tool.sh"
  printf '%s\n' '---' 'name: example' '---' >"${repo}/.agents/skills/example/SKILL.md"
  printf 'work\n' >"${repo}/.agents/skills/example/work/item"
  git -C "${repo}" add -f -A
  git -C "${repo}" commit -q -m 'test: create baseline'
}

reset_repo() {
  local repo="$1"
  git -C "${repo}" reset --hard -q HEAD
  git -C "${repo}" clean -fdx -q
}

stage_write() {
  local repo="$1" path="$2" content="${3:-changed}"
  mkdir -p "$(dirname "${repo}/${path}")"
  printf '%s\n' "${content}" >>"${repo}/${path}"
  git -C "${repo}" add -f -- "${path}"
}

stage_delete() {
  local repo="$1" path="$2"
  git -C "${repo}" rm -q -- "${path}"
}

checks=0
failures=0
expect_pre_commit() {
  local expected="$1" label="$2" repo="$3" status output
  checks=$((checks + 1))
  set +e
  output="$(cd "${repo}" && AGENTS_GLOBAL_SKILLS_ROOT="${SCRATCH}/no-global-skills" "${FIXTURE_HOOKS}/pre-commit" 2>&1)"
  status=$?
  set -e
  if { [[ "${expected}" == pass ]] && ((status == 0)); } ||
     { [[ "${expected}" == fail ]] && ((status != 0)); }; then
    printf 'ok %d - %s\n' "${checks}" "${label}"
  else
    printf 'not ok %d - %s (expected %s, status %d)\n%s\n' \
      "${checks}" "${label}" "${expected}" "${status}" "${output}" >&2
    failures=$((failures + 1))
  fi
}

expect_commit_msg() {
  local expected="$1" label="$2" repo="$3" message="$4" status output msg_file
  checks=$((checks + 1))
  msg_file="${SCRATCH}/commit-message-${checks}"
  printf '%s\n' "${message}" >"${msg_file}"
  set +e
  output="$(cd "${repo}" && "${FIXTURE_HOOKS}/commit-msg" "${msg_file}" 2>&1)"
  status=$?
  set -e
  if { [[ "${expected}" == pass ]] && ((status == 0)); } ||
     { [[ "${expected}" == fail ]] && ((status != 0)); }; then
    printf 'ok %d - %s\n' "${checks}" "${label}"
  else
    printf 'not ok %d - %s (expected %s, status %d)\n%s\n' \
      "${checks}" "${label}" "${expected}" "${status}" "${output}" >&2
    failures=$((failures + 1))
  fi
}

REPO="${SCRATCH}/repo"
NO_ROOT_REPO="${SCRATCH}/repo-without-root-agents"
init_repo "${REPO}" true
init_repo "${NO_ROOT_REPO}" false

blocked_paths=(
  'existing/AGENTS.override.md'
  'CLAUDE.md'
  'nested/CLAUDE.local.md'
  'nested/CLAUDE.extra'
  '.claude/settings.json'
  'sub/.pi/state'
  'ai_temp/item'
  'ai_logs/item'
  'ai_issues/item'
  'ai_tests/item'
  'ai_docs/item'
  '.agents/skills/example/work/item'
)
for path in "${blocked_paths[@]}"; do
  reset_repo "${REPO}"
  stage_delete "${REPO}" "${path}"
  expect_pre_commit pass "deletion allowed: ${path}" "${REPO}"
done

new_blocked_paths=(
  'nested/TEAM.override.md'
  'deeper/CLAUDE.md'
  'deeper/CLAUDE.local.md'
  'deeper/CLAUDE.notes'
  'deeper/.claude/settings.json'
  'deeper/.pi/state'
  'deeper/ai_temp/item'
  'deeper/ai_logs/item'
  'deeper/ai_issues/item'
  'deeper/ai_tests/item'
  'deeper/ai_docs/item'
  '.agents/skills/example/references/work/item'
)
for path in "${new_blocked_paths[@]}"; do
  reset_repo "${REPO}"
  stage_write "${REPO}" "${path}"
  expect_pre_commit fail "new blocked path rejected: ${path}" "${REPO}"
done

for path in "${blocked_paths[@]}"; do
  reset_repo "${REPO}"
  stage_write "${REPO}" "${path}"
  expect_pre_commit fail "tracked blocked path modification rejected: ${path}" "${REPO}"
done

for path in 'existing/AGENTS.md' 'existing/SUBAGENTS.md'; do
  reset_repo "${REPO}"
  stage_write "${REPO}" "${path}"
  expect_pre_commit pass "existing instruction modification allowed: ${path}" "${REPO}"
done

for path in 'new/deep/AGENTS.md' 'new/deep/SUBAGENTS.md'; do
  reset_repo "${REPO}"
  stage_write "${REPO}" "${path}"
  expect_pre_commit pass "new nested instruction allowed with root AGENTS.md: ${path}" "${REPO}"
done

for path in 'AGENTS.md' 'new/AGENTS.md' 'new/SUBAGENTS.md'; do
  reset_repo "${NO_ROOT_REPO}"
  stage_write "${NO_ROOT_REPO}" "${path}"
  expect_pre_commit fail "new instruction rejected without existing root AGENTS.md: ${path}" "${NO_ROOT_REPO}"
done

for path in 'ai_wiki/new.md' 'ai_scripts/new.sh' '.agents/skills/new-skill/SKILL.md'; do
  reset_repo "${REPO}"
  stage_write "${REPO}" "${path}"
  expect_pre_commit pass "existing governed tree may grow: ${path}" "${REPO}"
done

reset_repo "${REPO}"
stage_write "${REPO}" '.agents/skills/example/work/item'
expect_pre_commit fail 'tracked skill work modification rejected' "${REPO}"
reset_repo "${REPO}"
stage_write "${REPO}" 'notes/devin.txt'
expect_pre_commit fail 'blocked-name staged path remains rejected' "${REPO}"

expect_commit_msg fail 'blocked-name commit message remains rejected' "${REPO}" 'fix: ask devin to update'
expect_commit_msg fail 'literal backslash-n remains rejected' "${REPO}" 'fix: subject\nbody'
expect_commit_msg fail 'CLAUDE reference remains rejected for tracked legacy file' "${REPO}" 'docs: update CLAUDE.md'
expect_commit_msg fail 'private-root reference remains rejected' "${REPO}" 'docs: update ai_docs/guide.md'
expect_commit_msg fail 'skill work reference remains rejected' "${REPO}" 'docs: update .agents/skills/example/work/note.md'
expect_commit_msg pass 'existing ai_wiki reference remains allowed' "${REPO}" 'docs: update ai_wiki/index.md'
expect_commit_msg pass 'existing ai_scripts reference remains allowed' "${REPO}" 'docs: update ai_scripts/tool.sh'

status_after="${SCRATCH}/dotfiles-status.after"
worktree_after="${SCRATCH}/dotfiles-worktree.after"
index_after="${SCRATCH}/dotfiles-index.after"
hashes_after="${SCRATCH}/hook-hashes.after"
git -C "${DOTFILES_ROOT}" status --porcelain=v2 -z >"${status_after}"
git -C "${DOTFILES_ROOT}" diff --binary >"${worktree_after}"
git -C "${DOTFILES_ROOT}" diff --cached --binary >"${index_after}"
sha256sum \
  "${SOURCE_HOOKS}/pre-commit" \
  "${SOURCE_HOOKS}/commit-msg" \
  "${SOURCE_HOOKS}/check-blocked-value" \
  "${SOURCE_HOOKS}/check-skill-conflicts" \
  "${SOURCE_HOOKS}/blocked-names" \
  "${SOURCE_HOOKS}/blocked-patterns" >"${hashes_after}"
for pair in \
  "${before_status}:${status_after}:target status" \
  "${before_worktree}:${worktree_after}:target worktree diff" \
  "${before_index}:${index_after}:target index diff" \
  "${before_hashes}:${hashes_after}:source hook hashes"; do
  IFS=: read -r before after label <<<"${pair}"
  checks=$((checks + 1))
  if cmp -s -- "${before}" "${after}"; then
    printf 'ok %d - fixture preserved %s\n' "${checks}" "${label}"
  else
    printf 'not ok %d - fixture changed %s\n' "${checks}" "${label}" >&2
    failures=$((failures + 1))
  fi
done

if ((failures != 0)); then
  printf 'FAIL: %d of %d hook policy checks failed\n' "${failures}" "${checks}" >&2
  exit 1
fi
printf 'PASS: %d hook policy checks\n' "${checks}"
