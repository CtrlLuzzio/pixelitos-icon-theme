#!/bin/sh
set -eu

xdg="${XDG_DATA_HOME:-${HOME}/.local/share}"
DIR_DARK="${xdg}/icons/pixelitos-dark"
DIR_LIGHT="${xdg}/icons/pixelitos-light"
ICONS_128="${DIR_DARK}/128"

install_pixelitos_theme() {
	mkdir -p "${xdg}/icons"

	for pair in "./pixelitos-dark:${DIR_DARK}" "./pixelitos-light:${DIR_LIGHT}"; do
		src="${pair%%:*}"
		dest="${pair##*:}"
		rm -rf "${dest}"
		if cp -r "${src}" "${dest}"; then
			echo "DONE: Install ${dest}"
		else
			echo "Error: Failed to copy ${src} to ${dest}." >&2
			exit 1
		fi
	done

	if [ -f ./update.sh ]; then
		cp -v ./update.sh "${DIR_DARK}"
	fi
}

compile_icons() {
	echo "Compiling 128x128 icons..."
	if [ -x ./pixelitos-dark/compile-icons.sh ]; then
		if ./pixelitos-dark/compile-icons.sh; then
			echo "Icons compiled successfully!"
		else
			echo "Error: Failed to compile icons." >&2
			exit 1
		fi
	else
		echo "Error: compile-icons.sh missing or not executable." >&2
		exit 1
	fi
}

printf "Do you want to install 'Pixelitos icon theme'? (Y/n) "
read -r answer
answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
case "$answer" in
	y|yes|"") install_pixelitos_theme ;;
	n|no)     echo "Installation skipped." ;;
	*)        echo "Invalid input. Skipping installation." ;;
esac

if [ ! -d "${ICONS_128}" ]; then
	echo "${ICONS_128} folder does not exist. Compiling icons..."
	compile_icons
else
	printf "Do you want to (re)compile 128x128 icons? (Y/n) "
	read -r answer
	answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
	case "$answer" in
		y|yes|"") compile_icons ;;
		n|no)     echo "Skipping recompilation." ;;
		*)        echo "Invalid input. Skipping recompilation." ;;
	esac
fi