#!/usr/bin/env bash
set -euo pipefail

# Ensure Nix-specific overrides do not block Alire from managing toolchains
unset ALIRE_NO_TOOLCHAIN_INSTALL

TOOLS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/alire-tools"
BIN_DIR="$HOME/.local/bin"
PRECACHE_LIBS=("gnatcoll" "gnatcoll_gmp" "aws")

mkdir -p "$TOOLS_DIR" "$BIN_DIR"
export PATH="$BIN_DIR:$PATH"

echo "==> [1/4] Updating Alire community index..."
alr settings --global --set solver.timeout 60000
alr -n index --update-all

echo "==> [2/4] Installing native GNAT compiler and GPRbuild toolchain..."
alr -n toolchain --select gnat_native gprbuild

# Link gnatpp bundled inside gnat_native
#GNATPP_BIN="$(find "${XDG_DATA_HOME:-$HOME/.local/share}/alire" -type f -name gnatpp -executable 2>/dev/null | head -n 1 || true)"
#if [[ -n "$GNATPP_BIN" ]]; then
#	ln -sf "$GNATPP_BIN" "$BIN_DIR/gnatpp"
#fi

# Helper to fetch (and optionally compile) standalone Alire CLI tools
install_cli_crate() {
	local crate="$1"
	local binary="$2"
	local build_required="$3"

	echo "==> Installing CLI tool: $binary (from crate '$crate')..."
	cd "$TOOLS_DIR"
	rm -rf "${crate}"_*
	alr -n --force get "$crate"

	local crate_dir
	crate_dir="$(find "$TOOLS_DIR" -maxdepth 1 -type d -name "${crate}_*" | head -n 1)"

	if [[ "$build_required" == "true" ]]; then
		(cd "$crate_dir" && alr -n build --release)
	fi

	local bin_path
	bin_path="$(find "$crate_dir" -maxdepth 3 -type f -name "$binary" -executable | head -n 1)"

	if [[ -z "$bin_path" ]]; then
		echo "ERROR: Could not locate executable '$binary' in $crate_dir" >&2
		exit 1
	fi

	ln -sf "$bin_path" "$BIN_DIR/$binary"
}

echo "==> [3/4] Installing SPARK prover and Ada formatters..."
# gnatprove ships as a prebuilt binary archive in Alire
install_cli_crate "gnatprove" "gnatprove" "false"
# gnatformat is AdaCore's modern formatter (compiled from source)
install_cli_crate "gnatformat" "gnatformat" "true"
# Optional: uncomment the line below if you also want legacy gnatpp
# install_cli_crate "libadalang_tools" "gnatpp" "true"

echo "==> [4/4] Pre-caching Ada libraries (${PRECACHE_LIBS[*]})..."
TMP_SEED="$(mktemp -d)"
trap 'rm -rf "$TMP_SEED"' EXIT

cd "$TMP_SEED"
alr -n init --bin dotfiles_seed
cd dotfiles_seed
alr -n with "${PRECACHE_LIBS[@]}"
alr -n build

echo ""
echo "Ada + Alire environment configured successfully."
echo "Make sure '$BIN_DIR' is in your PATH."
echo "Done."
