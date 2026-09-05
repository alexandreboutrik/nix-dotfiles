#!/usr/bin/env bash

OLD_DIR="$HOME/.mozilla/firefox"
FLATPAK_DIR="$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox"

if [ -d "$OLD_DIR" ] && [ ! -f "$FLATPAK_DIR/.migrated" ]; then
	# Force-remove any existing Flatpak skeleton directories
	rm -rf "$FLATPAK_DIR"
	mkdir -p "$HOME/.var/app/org.mozilla.firefox/.mozilla"

	# Copy the host data to the Flatpak directory
	cp -a "$OLD_DIR" "$FLATPAK_DIR"

	# Extract the old profile directory string (e.g., 5xbfy2qv.default)
	PROFILE_PATH=$(grep -m 1 '^Path=' "$FLATPAK_DIR/profiles.ini" | cut -d '=' -f 2)

	# Rewrite profiles.ini to explicitly name your old profile as
	# 'default-release'
	cat >"$FLATPAK_DIR/profiles.ini" <<EOF
[Profile0]
Name=default-release
IsRelative=1
Path=$PROFILE_PATH
Default=1

[General]
StartWithLastProfile=1
Version=2
EOF

	# Purge installs.ini so Flatpak Firefox adopts the rewritten profile
	rm -f "$FLATPAK_DIR/installs.ini"

	# Create a lock file so this never overwrites future data
	touch "$FLATPAK_DIR/.migrated"
fi
