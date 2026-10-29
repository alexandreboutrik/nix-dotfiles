#!/usr/bin/env bash
#
# n-update: Deterministic NixOS system update, audit, and
#           release orchestrator.
#
# Performs a non-destructive dry-run build of candidate Nix flake inputs,
# previews package differences via nvd, and optionally applies the
# closure, commits lockfile changes, increments release tags, and pushes
# to upstream remotes.
#
# Usage:
#   n-update [HOST] [-y|--yes] [-c|--commit] [-p|--push] [-h|--help]
#
# Options:
#   -y, --yes     Bypass manual confirmation prompt; authenticate sudo
#                 upfront.
#   -c, --commit  Commit updated flake.lock with standard chore message.
#   -p, --push    Tag incremental release (vX.YY) and push main branch and
#                 tags. (Implicitly enables -c; prompts for SSH
#                 authentication upfront).
#   -h, --help		Display help message and exit.
#
# Dependencies:
#   nix, git, jq, nvd, sudo, ssh-add

set -euo pipefail

# --------------------------
# Formatting & Diagnostics
# --------------------------
RED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

subtext() {
	printf "%b--> %s%b\n" "${YELLOW}" "${1}" "${NC}"
}

success() {
	printf "%b%s%b\n" "${GREEN}" "${1}" "${NC}"
}

error() {
	printf "%bError:%b %s\n" "${RED}" "${NC}" "${1}" >&2
}

show_help() {
	cat <<EOF
Usage: n-update [HOST] [OPTIONS]

Deterministic NixOS system update, audit, and release orchestrator.

Arguments:
  HOST          Target NixOS hostname (defaults to current hostname)

Options:
  -y, --yes     Bypass confirmation prompt; authenticate sudo upfront
  -c, --commit  Commit updated flake.lock with standard chore message
  -p, --push    Tag release (vX.YY) and push to remote (implies -c)
  -h, --help    Display this help message and exit
EOF
}

apply_updates() {
	local dotfiles="$1"
	local host="$2"
	local do_commit="$3"
	local do_push="$4"

	# Rebuild and activate target system closure
	if ! sudo nixos-rebuild switch --flake "${dotfiles}#${host}"; then
		error "System activation failed. Aborting version control operations."
		return 1
	fi

	# Automated Git lockfile commit
	if [[ "${do_commit}" == true ]]; then
		subtext "Creating standard lockfile synchronization commit..."
		git -C "${dotfiles}" add flake.lock
		git -C "${dotfiles}" commit -m "chore: update flake.lock"
	fi

	# Automated release tagging and remote push
	if [[ "${do_push}" == true ]]; then
		# Ensure SSH agent credentials exist if push was confirmed interactively
		if ! ssh-add -l >/dev/null 2>&1; then
			if ! ssh-add; then
				error "Failed to load SSH keys into authentication agent."
				return 1
			fi
		fi

		local latest_tag new_tag
		latest_tag=$(git -C "${dotfiles}" tag -l "v*" --sort=-v:refname | head -n 1)
		if [[ -z "${latest_tag}" ]]; then
			latest_tag=$(git -C "${dotfiles}" describe --tags --abbrev=0 2>/dev/null || true)
		fi

		if [[ -z "${latest_tag}" ]]; then
			new_tag="v1.00"
		elif [[ "${latest_tag}" =~ ^v?([0-9]+)\.([0-9]+)$ ]]; then
			local major="${BASH_REMATCH[1]}"
			local minor="${BASH_REMATCH[2]}"
			local minor_num=$((10#${minor} + 1))
			local pad=${#minor}
			local new_minor
			printf -v new_minor "%0*d" "${pad}" "${minor_num}"
			new_tag="v${major}.${new_minor}"
		else
			error "Cannot parse semantic version from tag '${latest_tag}'. Expected 'vX.YY'."
			return 1
		fi

		subtext "Publishing release tag ${new_tag} (previous: ${latest_tag:-initial})..."
		git -C "${dotfiles}" tag "${new_tag}"

		subtext "Pushing main branch and tags to upstream remote..."
		git -C "${dotfiles}" push origin main && git -C "${dotfiles}" push origin main --tags
	fi
}

parse_args() {
	for arg in "$@"; do
		case "${arg}" in
		-h | --help)
			show_help
			exit 0
			;;
		-y | --yes)
			auto_yes=true
			;;
		-c | --commit)
			auto_commit=true
			;;
		-p | --push)
			auto_push=true
			auto_commit=true
			;;
		-[a-zA-Z]*)
			# Parse clustered short options (e.g., -ycp, -yp)
			local i
			for ((i = 1; i < ${#arg}; i++)); do
				local char="${arg:$i:1}"
				case "$char" in
				h)
					show_help
					exit 0
					;;
				y) auto_yes=true ;;
				c) auto_commit=true ;;
				p)
					auto_push=true
					auto_commit=true
					;;
				*)
					error "Unrecognized option '-${char}'."
					return 1
					;;
				esac
			done
			;;
		*)
			if [[ -z "${host}" ]]; then
				host="${arg}"
			fi
			;;
		esac
	done

	host="${host:-"$(hostname)"}"
}

main() {
	local dotfiles="${NIX_DOTFILES:-"${HOME}/nix-dotfiles"}"
	local host=""
	local auto_yes=false
	local auto_commit=false
	local auto_push=false

	parse_args "$@"

	if [[ ! -d "${dotfiles}" || ! -f "${dotfiles}/flake.lock" ]]; then
		error "Flake repository root or flake.lock not found at '${dotfiles}'."
		return 1
	fi

	# --------------------------
	# Upfront Credential Acquisition
	# --------------------------
	if [[ "${auto_yes}" == true ]]; then
		subtext "Acquiring privileged sudo authentication upfront..."
		if ! sudo -v; then
			error "Failed to validate sudo authorization."
			return 1
		fi
	fi

	if [[ "${auto_push}" == true ]]; then
		subtext "Validating active SSH agent credentials..."
		if ! ssh-add -l >/dev/null 2>&1; then
			if ! ssh-add; then
				error "Failed to load SSH keys into authentication agent."
				return 1
			fi
		fi
	fi

	# --------------------------
	# Upstream Input Inspection & Update
	# --------------------------
	local OLD_NIXPKGS_REV OLD_HM_REV
	OLD_NIXPKGS_REV=$(nix flake metadata "${dotfiles}" --json 2>/dev/null | jq -r '.locks.nodes.nixpkgs.locked.rev // empty')
	OLD_HM_REV=$(nix flake metadata "${dotfiles}" --json 2>/dev/null | jq -r '.locks.nodes["home-manager"].locked.rev // empty')
	subtext "Current nixpkgs commit:      ${OLD_NIXPKGS_REV:-unknown}"
	subtext "Current home-manager commit: ${OLD_HM_REV:-unknown}"

	subtext "Updating flake lock inputs (nixpkgs & home-manager)..."
	local update_err
	if ! update_err=$(nix flake update --no-warn-dirty --flake "${dotfiles}" 2>&1); then
		error "Failed to update flake inputs:\n${update_err}"
		return 1
	fi

	local NEW_NIXPKGS_REV NEW_HM_REV
	NEW_NIXPKGS_REV=$(nix flake metadata "${dotfiles}" --json 2>/dev/null | jq -r '.locks.nodes.nixpkgs.locked.rev // empty')
	NEW_HM_REV=$(nix flake metadata "${dotfiles}" --json 2>/dev/null | jq -r '.locks.nodes["home-manager"].locked.rev // empty')
	subtext "Target nixpkgs commit:       ${NEW_NIXPKGS_REV:-unknown}"
	subtext "Target home-manager commit:  ${NEW_HM_REV:-unknown}"

	# Exit early if inputs did not advance
	if git -C "${dotfiles}" diff --quiet flake.lock; then
		success "No upstream updates available. flake.lock is already at the latest revision."
		return 0
	fi

	# --------------------------
	# Candidate Build & Verification (Dry Run)
	# --------------------------
	subtext "Building candidate system closure for host '${host}' (no activation)..."
	local OUT_LINK="/tmp/result-check"
	rm -f "${OUT_LINK}"

	if ! nix build --no-warn-dirty "${dotfiles}#nixosConfigurations.${host}.config.system.build.toplevel" --out-link "${OUT_LINK}"; then
		error "Build failure detected. Reverting flake.lock modifications."
		git -C "${dotfiles}" restore flake.lock
		rm -f "${OUT_LINK}"
		return 1
	fi

	# --------------------------
	# Package Closure Diff Inspection
	# --------------------------
	subtext "Evaluating closure package differences (nvd)..."
	nvd diff /run/current-system "${OUT_LINK}"
	rm -f "${OUT_LINK}"

	# --------------------------
	# Promotion & Deployment Decision
	# --------------------------
	local CONFIRM
	if [[ "${auto_yes}" == true ]]; then
		success "Automatic confirmation flag active. Initiating system switch..."
		CONFIRM="y"
	else
		read -rp "Would you like to keep these flake updates? [y/N]: " CONFIRM
	fi

	if [[ "${CONFIRM}" =~ ^[Yy]$ ]]; then
		success "Retaining candidate flake.lock."

		# Prompt for commit and push if running interactively and not
		# passed via CLI
		if [[ "${auto_yes}" == false && "${auto_commit}" == false ]]; then
			local confirm_commit
			read -rp "Commit updated flake.lock? [y/N]: " confirm_commit
			if [[ "${confirm_commit}" =~ ^[Yy]$ ]]; then
				auto_commit=true
			fi
		fi

		if [[ "${auto_yes}" == false && "${auto_commit}" == true && "${auto_push}" == false ]]; then
			local confirm_push
			read -rp "Tag release and push to origin main? [y/N]: " confirm_push
			if [[ "${confirm_push}" =~ ^[Yy]$ ]]; then
				auto_push=true
			fi
		fi

		if ! apply_updates "${dotfiles}" "${host}" "${auto_commit}" "${auto_push}"; then
			return 1
		fi
	else
		subtext "Reverting lockfile modifications..."
		git -C "${dotfiles}" restore flake.lock
		success "Operation aborted. System state and directory remain untouched."
	fi
}

main "$@"
