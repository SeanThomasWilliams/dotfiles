#!/usr/bin/env bash
# install-github-runner.sh installs/updates a GitHub Actions self-hosted runner.
# Default scope is org-level for xeedio (https://github.com/xeedio).
# Uses a one-time registration token from an environment variable.
# Includes prerequisite checks, idempotent reruns, systemd setup, and test mode.
# Supports Ubuntu 22.04+ and Debian 12+ on Linux x64 hosts.
# Usage: ./install-github-runner.sh [options]

set -euo pipefail

runner_url="https://github.com/xeedio"
labels="self-hosted,linux,x64"
work_dir="/opt/actions-runner"
runner_user="$(id -un)"
GITHUB_RUNNER_TOKEN="${GITHUB_RUNNER_TOKEN:-}"
runner_version=""
test_mode=0
run_test_seconds=20

api_base="https://api.github.com"
archive_url=""
archive_name=""
tmp_archive=""
created_work_dir=0

usage() {
	cat <<'EOF'
Usage: install-github-runner.sh [options]

Install or update a GitHub Actions self-hosted runner (linux-x64) and run it
as a systemd service.

Options:
  --org ORG           Register at org scope (sets --url https://github.com/ORG)
  --repo OWNER/REPO   Register at repo scope (sets --url https://github.com/OWNER/REPO)
  --url URL           Explicit registration URL (default: https://github.com/xeedio)
  --labels LABELS     Comma-separated labels (default: self-hosted,linux,x64)
  --work-dir PATH     Runner install/work directory (default: /opt/actions-runner)
  --user USER         OS user that owns/runs the runner service (default: current user)
  --token TOKEN       One-time runner registration token (overrides env var)
  --version VERSION   Runner version override (example: 2.332.0)
  --test              Validate prerequisites/connectivity only (no install)
  -h, --help          Show this help message

Token:
  Export a one-time registration token from GitHub Settings -> Actions -> Runners
  before running install mode. Example:
    export GITHUB_RUNNER_TOKEN="<token>"

Examples:
  ./install-github-runner.sh --test
  ./install-github-runner.sh --org xeedio
  ./install-github-runner.sh --repo xeedio/rr-portal --labels self-hosted,linux,x64,portal
EOF
}

log() {
	printf '[install-github-runner] %s\n' "$*"
}

warn() {
	printf '[install-github-runner] Warning: %s\n' "$*" >&2
}

fail() {
	printf '[install-github-runner] Error: %s\n' "$*" >&2
	exit 1
}

run_as_root() {
	if [[ "$(id -u)" -eq 0 ]]; then
		"$@"
		return
	fi

	command -v sudo >/dev/null 2>&1 || fail "sudo is required for privileged operations"
	sudo "$@"
}

run_as_user() {
	local target_user="$1"
	shift

	if [[ "$(id -un)" == "${target_user}" ]]; then
		"$@"
		return
	fi

	if [[ "$(id -u)" -eq 0 ]]; then
		if command -v runuser >/dev/null 2>&1; then
			runuser -u "${target_user}" -- "$@"
		else
			su -s /bin/bash - "${target_user}" -c "$(printf '%q ' "$@")"
		fi
		return
	fi

	command -v sudo >/dev/null 2>&1 || fail "sudo is required to run commands as ${target_user}"
	sudo -u "${target_user}" "$@"
}

cleanup() {
	local exit_code=$?

	if [[ -n "${tmp_archive}" && -f "${tmp_archive}" ]]; then
		rm -f "${tmp_archive}"
	fi

	if [[ ${exit_code} -ne 0 && ${created_work_dir} -eq 1 ]]; then
		warn "Cleaning up partially created work directory: ${work_dir}"
		run_as_root rm -rf "${work_dir}" || true
	fi
}

trap cleanup EXIT

require_cmd() {
	local cmd="$1"
	command -v "${cmd}" >/dev/null 2>&1 || fail "Missing required command: ${cmd}"
}

check_connectivity() {
	local url="$1"
	curl -fsS --max-time 10 "${url}" >/dev/null
}

check_write_access() {
	if [[ -d "${work_dir}" ]]; then
		run_as_root test -w "${work_dir}" || fail "No write access to ${work_dir}"
		return
	fi

	local parent_dir
	parent_dir="$(dirname "${work_dir}")"
	[[ -d "${parent_dir}" ]] || fail "Parent directory does not exist: ${parent_dir}"
	run_as_root test -w "${parent_dir}" || fail "No write access to parent directory: ${parent_dir}"
}

check_distro_support() {
	[[ -f /etc/os-release ]] || fail "Cannot verify distro support: /etc/os-release missing"

	# shellcheck disable=SC1091
	. /etc/os-release
	local major_version="${VERSION_ID%%.*}"

	case "${ID}" in
	ubuntu)
		((major_version >= 22)) || fail "Unsupported Ubuntu ${VERSION_ID}; requires 22.04+"
		;;
	debian)
		((major_version >= 12)) || fail "Unsupported Debian ${VERSION_ID}; requires 12+"
		;;
	*)
		fail "Unsupported distro '${ID}'. Supported: Ubuntu 22.04+ and Debian 12+"
		;;
	esac
}

check_prerequisites() {
	require_cmd curl
	require_cmd jq
	require_cmd tar
	require_cmd systemctl

	[[ "$(uname -s)" == "Linux" ]] || fail "Only Linux hosts are supported"
	case "$(uname -m)" in
	x86_64 | amd64) ;;
	*) fail "Only linux-x64 is supported" ;;
	esac

	[[ "$(ps -p 1 -o comm=)" == "systemd" ]] || fail "systemd is required (PID 1 is not systemd)"
	id "${runner_user}" >/dev/null 2>&1 || fail "Runner user does not exist: ${runner_user}"

	check_distro_support
	check_write_access

	log "Checking network connectivity to github.com"
	check_connectivity "https://github.com" || fail "Cannot reach https://github.com"
	log "Checking network connectivity to api.github.com"
	check_connectivity "https://api.github.com" || fail "Cannot reach https://api.github.com"
}

resolve_runner_release() {
	if [[ -n "${runner_version}" ]]; then
		return
	fi

	local tag
	tag="$(curl -fsSL "${api_base}/repos/actions/runner/releases/latest" | jq -r '.tag_name // empty')"
	[[ -n "${tag}" ]] || fail "Failed to determine latest actions/runner release"
	runner_version="${tag#v}"
}

build_release_urls() {
	archive_name="actions-runner-linux-x64-${runner_version}.tar.gz"
	archive_url="https://github.com/actions/runner/releases/download/v${runner_version}/${archive_name}"
}

stop_uninstall_existing_service() {
	if run_as_root test -x "${work_dir}/svc.sh"; then
		log "Stopping existing runner service if present"
		run_as_root bash -lc "cd $(printf '%q' "${work_dir}") && ./svc.sh stop" || true
		run_as_root bash -lc "cd $(printf '%q' "${work_dir}") && ./svc.sh uninstall" || true
	fi
}

clean_install_dir() {
	local entry
	local base

	shopt -s dotglob nullglob
	for entry in "${work_dir}"/*; do
		base="$(basename "${entry}")"
		if [[ "${base}" == "_work" ]]; then
			continue
		fi
		run_as_root rm -rf "${entry}"
	done
	shopt -u dotglob nullglob
}

prepare_work_dir() {
	if [[ ! -d "${work_dir}" ]]; then
		run_as_root mkdir -p "${work_dir}"
		created_work_dir=1
	fi

	stop_uninstall_existing_service
	clean_install_dir
}

download_runner_archive() {
	tmp_archive="$(mktemp "/tmp/${archive_name}.XXXX")"

	log "Downloading runner archive ${archive_name}"
	curl -fsSL "${archive_url}" -o "${tmp_archive}"
}

extract_runner() {
	log "Extracting runner into ${work_dir}"
	run_as_root tar -xzf "${tmp_archive}" -C "${work_dir}"
	run_as_root chown -R "${runner_user}:${runner_user}" "${work_dir}"
}

configure_runner() {
	local token_value="$1"
	local runner_name
	runner_name="$(hostname -s)"

	log "Configuring runner '${runner_name}' for ${runner_url}"
	run_as_user "${runner_user}" "${work_dir}/config.sh" \
		--unattended \
		--replace \
		--url "${runner_url}" \
		--token "${token_value}" \
		--name "${runner_name}" \
		--labels "${labels}" \
		--work "_work"
}

install_and_start_service() {
	log "Installing systemd service for runner user ${runner_user}"
	run_as_root bash -lc "cd $(printf '%q' "${work_dir}") && ./svc.sh install $(printf '%q' "${runner_user}")"
	log "Starting runner service"
	run_as_root bash -lc "cd $(printf '%q' "${work_dir}") && ./svc.sh start"
	log "Verifying runner service via svc.sh status"
	run_as_root bash -lc "cd $(printf '%q' "${work_dir}") && ./svc.sh status"
}

quick_run_smoke_test() {
	log "Running quick smoke test via ./run.sh for ${run_test_seconds}s"
	local run_status=0
	set +e
	run_as_user "${runner_user}" timeout "${run_test_seconds}s" "${work_dir}/run.sh"
	run_status=$?
	set -e

	if [[ ${run_status} -ne 0 && ${run_status} -ne 124 ]]; then
		fail "Runner smoke test failed (run.sh exit code: ${run_status})"
	fi

	log "Runner smoke test completed"
}

validate_runner_online() {
	log "Validating runner online status via local diagnostics"
	local attempts=24
	local i
	local latest_log

	for ((i = 1; i <= attempts; i++)); do
		latest_log="$(ls -1t "${work_dir}"/_diag/Runner_*.log 2>/dev/null | head -n 1 || true)"
		if [[ -n "${latest_log}" ]] && grep -q "Listening for Jobs" "${latest_log}"; then
			log "Runner reported online state (Listening for Jobs)"
			return
		fi
		sleep 5
	done

	fail "Runner did not report online state within timeout"
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--org)
		[[ $# -ge 2 ]] || fail "--org requires a value"
		runner_url="https://github.com/$2"
		shift 2
		;;
	--repo)
		[[ $# -ge 2 ]] || fail "--repo requires a value"
		[[ "$2" == */* ]] || fail "--repo must be OWNER/REPO"
		runner_url="https://github.com/$2"
		shift 2
		;;
	--url)
		[[ $# -ge 2 ]] || fail "--url requires a value"
		runner_url="$2"
		shift 2
		;;
	--labels)
		[[ $# -ge 2 ]] || fail "--labels requires a value"
		labels="$2"
		shift 2
		;;
	--work-dir)
		[[ $# -ge 2 ]] || fail "--work-dir requires a value"
		work_dir="$2"
		shift 2
		;;
	--user)
		[[ $# -ge 2 ]] || fail "--user requires a value"
		runner_user="$2"
		shift 2
		;;
	--token)
		[[ $# -ge 2 ]] || fail "--token requires a value"
		GITHUB_RUNNER_TOKEN="$2"
		shift 2
		;;
	--version)
		[[ $# -ge 2 ]] || fail "--version requires a value"
		runner_version="$2"
		shift 2
		;;
	--test)
		test_mode=1
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		fail "Unknown argument: $1"
		;;
	esac
done

check_prerequisites
resolve_runner_release
build_release_urls

token_value="${GITHUB_RUNNER_TOKEN}"
[[ -n "${token_value}" ]] || fail "Environment variable GITHUB_RUNNER_TOKEN is required"

log "Runner URL: ${runner_url}"
log "Runner version: ${runner_version}"
log "Labels: ${labels}"
log "Work directory: ${work_dir}"
log "Runner user: ${runner_user}"

if [[ ${test_mode} -eq 1 ]]; then
	log "Test mode complete: prerequisites and connectivity checks passed"
	exit 0
fi

prepare_work_dir
download_runner_archive
extract_runner
configure_runner "${token_value}"
quick_run_smoke_test
install_and_start_service
validate_runner_online

log "Runner installation completed successfully"
