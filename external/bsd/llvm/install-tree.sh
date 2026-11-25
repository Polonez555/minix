#!/bin/sh
#
# MINIX: install a staged CMake install tree into DESTDIR with the BSD
# install commands, so that every directory, file and link is recorded
# in METALOG like any other part of the build.
#
# Usage: install-tree.sh <stage dir> <destdir>
#
# The install commands come from the environment, as bsd.own.mk defines
# them: INSTALL_DIR, INSTALL_FILE, INSTALL_SYMLINK, plus the owner, group
# and modes FILEOWN, FILEGRP, FILEMODE (plain files), EXECMODE (files that
# are executable in the stage), DIRMODE, DEBUGMODE.

set -e

stage=$1
destdir=$2

if [ -z "${stage}" ] || [ -z "${destdir}" ]; then
	echo "usage: $0 <stage dir> <destdir>" >&2
	exit 1
fi

cd "${stage}"

find . -type d ! -name . | sort | while read -r d; do
	${INSTALL_DIR} -o "${FILEOWN}" -g "${FILEGRP}" -m "${DIRMODE}" \
	    "${destdir}/${d#./}"
done

find . -type f | sort | while read -r f; do
	case "${f}" in
	*.debug)	mode=${DEBUGMODE} ;;
	*)		if [ -x "${f}" ]; then
				mode=${EXECMODE}
			else
				mode=${FILEMODE}
			fi ;;
	esac
	${INSTALL_FILE} -o "${FILEOWN}" -g "${FILEGRP}" -m "${mode}" \
	    "${f}" "${destdir}/${f#./}"
done

find . -type l | sort | while read -r l; do
	${INSTALL_SYMLINK} "$(readlink "${l}")" "${destdir}/${l#./}"
done
