#!/bin/bash
set -euo pipefail

xdg="${XDG_DATA_HOME:-${HOME}/.local/share}"
expected_dir="${xdg}/icons/pixelitos-icon-theme"

echo "Current directory: $PWD"

if [ "$(pwd -P)" != "$(cd "$expected_dir" 2>/dev/null && pwd -P)" ]; then
	echo "ERROR: Please run this script from inside '${expected_dir}'" >&2
	exit 1
fi

cd ..
ln -sv "${expected_dir}/pixelitos-dark" pixelitos-dark || true
ln -sv "${expected_dir}/pixelitos-light" pixelitos-light || true

cd pixelitos-dark
if [ ! -x ./compile-icons.sh ]; then
	echo "ERROR: compile-icons.sh not found or not executable in $(pwd)" >&2
	exit 1
fi
./compile-icons.sh

echo "Icons installed in '${xdg}' as Symlinks"