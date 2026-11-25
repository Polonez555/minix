#!/bin/sh
#
# MINIX: apply the MINIX patches to the llvm-project submodule checkout.
#
# Usage: apply-patches.sh <llvm-project dir> <patch dir>
#
# Patches are applied in name order.  A patch that is already applied is
# skipped, so the script can be run before every build.  Nothing is ever
# committed inside the submodule.

set -e

dist=$1
patches=$2

if [ -z "${dist}" ] || [ -z "${patches}" ]; then
	echo "usage: $0 <llvm-project dir> <patch dir>" >&2
	exit 1
fi

# git -C changes directory, so use absolute paths.
dist=$(cd "${dist}" && pwd)
patches=$(cd "${patches}" && pwd)

for p in "${patches}"/*.patch; do
	[ -f "${p}" ] || continue
	if git -C "${dist}" apply --reverse --check "${p}" 2>/dev/null; then
		continue
	fi
	echo "Applying $(basename "${p}")"
	git -C "${dist}" apply "${p}"
done
