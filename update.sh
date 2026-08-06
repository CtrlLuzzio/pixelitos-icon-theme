#!/bin/bash
set -euo pipefail

xdg="${XDG_DATA_HOME:-${HOME}/.local/share}"
expected_dir="${xdg}/icons/pixelitos-icon-theme"

echo "Current directory: $PWD"

if [ "$(pwd -P)" != "$(cd "$expected_dir" 2>/dev/null && pwd -P)" ]; then
	echo "ERROR: Please run this script from inside '${expected_dir}'" >&2
	exit 1
fi

git pull --verbose

if [ ! -x ./pixelitos-dark/compile-icons.sh ]; then
	echo "ERROR: compile-icons.sh not found or not executable" >&2
	exit 1
fi

echo "recompiling icons..."
./pixelitos-dark/compile-icons.sh