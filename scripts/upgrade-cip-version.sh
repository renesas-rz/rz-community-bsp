#!/bin/bash
#SPDX-License-Identifier: MIT

# This script assumes that git is already installed and the user name and email
# are configured as required.

set -uo pipefail

SCRIPT_NAME="$0"

# Set variable defaults
DEBUG=false
LINUX_REPO="https://gitlab.com/cip-project/cip-kernel/linux-cip.git"
NO_COMMIT=false
SLTS_VER=""

print_help () {
	cat<<EOF

	This script updates the recipe for the specified CIP Linux version to
	use the latest SLTS release from the CIP project. Once the code changes
	are completed they are checked in to the local rz-community-bsp git
	project.

	This script assumes that git is already installed and the user name and
	email are configured as required. The script is designed to be run from
	within the rz-community-bsp directory.

	USAGE: ${SCRIPT_NAME} \\
		[-n] [-r REPO] \\
		[-d] [-h] \\
		-v <SLTS_VERSION>

	OPTIONS:
	-d, --debug
		Enable the output of various information useful for script
		debugging.
	-n, --no-commit
		Only make the code changes. Do not commit the changes to git.
	-r, -repo
		Linux kernel repository to check for newer releases. By default
		https://gitlab.com/cip-project/cip-kernel/linux-cip.git is used.
	-v, --slts-version
		The SLTS version to upgrade. e.g. "5.10" or "6.1".
	-h, --help
		Print this help and exit.

EOF
}

parse_options () {
	print_debug "Entering parse_options()"

	while [[ $# -gt 0 ]]; do
	case $1 in
	-d|--debug)
		DEBUG=true
		shift
		;;
	-n|--no-commit)
		NO_COMMIT=true
		shift
		;;
	-r|--repo)
		LINUX_REPO="${2}"
		shift 2
		;;
	-v|--slts-version)
		if [ -e meta-rz-bsp/recipes-kernel/linux/linux-cip_"${2}".bb ]; then
			print_debug "Found linux-cip_${2}.bb"
			SLTS_VER="${2}"
			shift 2
		else
			print_error "For option '${1}', '${2}' is not a supported SLTS version"
			print_help
			exit 1
		fi
		;;
	-h|--help)
		print_help
		exit 1
		;;
	*)
		print_error "Option '${1}' is unknown."
		print_help
		exit 1
		;;
	esac
	done
}

check_manditory_arguments () {
	print_debug "Entering check_manditory_arguments()"

	if [ -z "${SLTS_VER}" ]; then
		print_error "Option -v|--slts-version must be provided."
		print_help
		exit 1
	fi
}

print_error () {
	echo 1>&2
	echo "######## ERROR ########" 1>&2
	echo "$@" 1>&2
	echo "#######################" 1>&2
	echo 1>&2
	debug_print_variables
}

print_debug () {
	if ${DEBUG}; then
		echo "### DEBUG: ${*}" 1>&2
	fi
}

debug_print_variables () {
	print_debug "Entering debug_print_variables()"

	print_debug "DEBUG=${DEBUG}"
	print_debug "LINUX_REPO=${LINUX_REPO}"
	print_debug "SLTS_VER=${SLTS_VER}"
	print_debug "NO_COMMIT=${NO_COMMIT}"
}

uncommitted_change_check () {
	print_debug "Entering uncommitted_change_check()"

	if ! git diff-index --quiet HEAD meta-rz-bsp/recipes-kernel/linux/linux-cip_"${SLTS_VER}".bb; then
		print_error "linux-cip_${SLTS_VER}.bb has uncommitted changes."
		exit 1
	fi
}

get_latest_tag () {
	print_debug "Entering get_latest_tag()"
	echo "Finding latest SLTS tag for v${SLTS_VER}."

	LATEST_TAG=$(git ls-remote --tags "${LINUX_REPO}" \
		| grep -o 'refs/tags/'"v${SLTS_VER}."'[0-9]\+-cip[0-9]\+$' \
		| sed 's|refs/tags/||' \
		| sort -V -r \
		| head -n 1)

	if [ -z "${LATEST_TAG}" ]; then
	    print_error "No tags found for SLTS v${SLTS_VER} matching v${SLTS_VER}.XXX-cipYY"
	    exit 1
	fi

	TAG_SHA=$(git ls-remote --tags "${LINUX_REPO}" "refs/tags/${LATEST_TAG}^{}" \
		| awk '{print $1}')

	echo "Latest tag for SLTS v${SLTS_VER} is ${LATEST_TAG}. SHA ${TAG_SHA}"
}

get_current_tag () {
	print_debug "Entering get_current_tag()"

	CURRENT_TAG="v$(grep LINUX_VERSION meta-rz-bsp/recipes-kernel/linux/linux-cip_"${SLTS_VER}".bb | cut -d'"' -f2)"
}

update_recipe () {
	print_debug "Entering update_recipe()"

	# Strip out the 'v' from the tag name
	local recipe_ver="${LATEST_TAG//v}"
	sed -i "s|LINUX_VERSION.*|LINUX_VERSION = \"${recipe_ver}\"|g" meta-rz-bsp/recipes-kernel/linux/linux-cip_"${SLTS_VER}".bb
	sed -i "s|SRCREV.*|SRCREV = \"${TAG_SHA}\"|g" meta-rz-bsp/recipes-kernel/linux/linux-cip_"${SLTS_VER}".bb
}

create_commit () {
	print_debug "Entering create_commit()"

	git add meta-rz-bsp/recipes-kernel/linux/linux-cip_"${SLTS_VER}".bb
	git commit -qsm "meta-rz-bsp: linux-cip_${SLTS_VER}: Update to SLTS ${LATEST_TAG}" && \
		echo "New commit created:" && \
		echo "##################################################" && \
		git show -1 && \
		echo "##################################################"
}

# Parse command line arguments
parse_options "$@"

# Check manditory arguments have been set
check_manditory_arguments

# Print value of each of the variables
debug_print_variables

# Check for uncommited changes
uncommitted_change_check

# Get latest CIP SLTS version
get_latest_tag

# Get current CIP SLTS version used in recipe
get_current_tag

if [ "${LATEST_TAG}" != "${CURRENT_TAG}" ]; then
	# Update recipe
	update_recipe

	# Create git commit if requested
	if ! ${NO_COMMIT}; then
		create_commit
	else
		echo "Changes made but not committed:" && \
		echo "##################################################" && \
		git diff meta-rz-bsp/recipes-kernel/linux/linux-cip_"${SLTS_VER}".bb && \
		echo "##################################################"
	fi
else
	echo "linux-cip_${SLTS_VER}.bb is already using the latest release."
fi

echo "DONE!"
