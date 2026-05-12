#!/bin/bash
#SPDX-License-Identifier: MIT

# This script assumes that lavacli is already installed and that the
# ~/.config/lavacli.yml file has been configured correctly.
# It also depends on the yq tool

set -uo pipefail

SCRIPT_NAME="$0"

# Set variable defaults
DEBUG=false
SUBMIT_ONLY=false
LAVACLI_IDENTITY=default
TEST_FILES=()
TEMPLATE_FILES=()

setup () {
	print_debug "Entering setup()"

	# Create temp directory
	TMP="$(mktemp -d)"
}

cleanup () {
	print_debug "Entering cleanup()"

	# Remove temp directory
	rm -rf "${TMP}"
}

print_help () {
	cat<<EOF

	This script creates a LAVA job definition, submits it to LAVA and
	gathers the test results once the job has completed.

	This script assumes that the lavacli application is already installed
	and that the ~/.config/lavacli.yml file has been configured correctly.

	USAGE: ${SCRIPT_NAME} \\
	        [-f DIR] [-g JOB_ID] [-i LAVACLI_IDENTITY] [-j DIR] [-s] \\
	        [-t TEST_DEFINITION] [-u USER] [-B BASE_URL] \\
	        [-Ud DTB_URL] [-Uk KERNEL_URL] [-Ur ROOTFS_URL] \\
	        [-Uf FW_URL] [-Ub BL2_URL] [-Ui FIP_URL] \\
	        [-U0 SA0_URL] [-U6 SA6_URL] [-U3 BL31_URL] [-Uu UBOOT_URL] \\
	        [-d] [-h] -l LAVA_TEMPLATE -e ENV

	One of the following three options must be used to provide binary URLs:

	  Option 1 - GitLab CI mode:
	    Provide -g|--build-job and -f|--test-file-dir. The URLs for all
	    binaries will be calculated automatically from the GitLab CI
	    artifact storage.

	  Option 2 - Base URL mode:
	    Provide -B|--base-url. The URLs for all binaries will be
	    calculated by combining the base URL with the filenames found
	    in the env file provided by -e.

	  Option 3 - Explicit URL mode:
	    Provide -Ud, -Uk and -Ur (and optionally -Uf, -Ub, -Ui, -U0,
	    -U6, -U3, -Uu) to specify the URLs for each binary individually.

	OPTIONS:
	-d, --debug
	        Enable the output of various information useful for script
	        debugging.
	-e, --env-file <ENV>
	        Use this option to specify a file containing environment values
	        that this script will use to create the LAVA job template.
	-f, --test-file-dir <DIR>
	        GitLab artifact directory containing the binaries needed for
	        testing in LAVA.
	        This option must be provided if --build-job is provided.
	        This option will be ignored if --build-job is not provided.
	-g, --build-job <JOB_ID>
	        The GitLab job ID of the build CI job that is providing the
	        binaries that are to be used for this LAVA job.
	        If this option is provided the URL locations for all binaries
	        will be calculated automatically.
	        Cannot be used with -B or -Ud/-Uk/-Ur.
	-i, --lavacli-identity <IDENTITY>
	        The lavacli identity to use to submit the LAVA job. This must
	        match one of the identities listed in ~/.config/lavacli.yml. If
	        this option is omitted the ${LAVACLI_IDENTITY} identity will be
	        used.
	-j, --junit-dir <DIR>
	        Save the LAVA test results in junit format to a file in the
	        specified directory. The file will be called
	        "results_<lava-job-number>.xml".
	        If this argument is not provided or --submit-only is set, the
	        test results will not be saved to a file.
	        This option depends on the yq tool.
	-l, --lava-template <LAVA_TEMPLATE>
	        Use this template file as the base for the LAVA job definition.
	        This script will replace PLACEHOLDER variables in the template
	        file with the corresponding values from the env file provided
	        by the -e option.
	        This option can be provided multiple times. The files will be
	        combined into a single job definition in the order provided.
	-s, --submit-only
	        Submit LAVA job only; don't wait for the job to complete and
	        don't gather the test results.
	-t, --test-definition <TEST_DEFINITION>
	        Use this option to specify a test case in LAVA yaml format to be
	        included in the LAVA test definition.
	        This option can be provided multiple times or not at all.
	-u, --lava-user <USER>
	        User account on the LAVA server to send email reports to. If not
	        provided, no notifications will be sent.
	-B, --base-url <BASE_URL>
	        A base URL to be combined with the filenames found in the env
	        file to produce the full URL for each binary. For example, if
	        the base URL is "https://example.com/builds" and the env file
	        contains "KERNEL=Image", the kernel URL will be
	        "https://example.com/builds/Image".
	        Cannot be used with -g or any of the -U* options.
	-Ud, --url-dtb
	        The URL location/directory where the LAVA dispatcher can
	        download the DTB binary from. It should not include the actual
	        filename of the binary. The filename is extracted from the ENV
	        file.
	-Uk, --url-kernel
	        The URL location/directory where the LAVA dispatcher can
	        download the Linux kernel binary from. It should not include the
	        actual filename of the binary. The filename is extracted from
	        the ENV file.
	-Ur, --url-rootfs
	        The URL location/directory where the LAVA dispatcher can
	        download the rootfs archive from. It should not include the
	        actual filename of the binary. The filename is extracted from
	        the ENV file.
	-Uf, --url-fw
	        The URL location/directory where the LAVA dispatcher can
	        download the firmware binary from.
	-Ub, --url-bl2
	        The URL location/directory where the LAVA dispatcher can
	        download the BL2 binary from.
	-Ui, --url-fip
	        The URL location/directory where the LAVA dispatcher can
	        download the FIP binary from.
	-U0, --url-sa0
	        The URL location/directory where the LAVA dispatcher can
	        download the SA0 binary from.
	-U6, --url-sa6
	        The URL location/directory where the LAVA dispatcher can
	        download the SA6 binary from.
	-U3, --url-bl31
	        The URL location/directory where the LAVA dispatcher can
	        download the BL31 binary from.
	-Uu, --url-uboot
	        The URL location/directory where the LAVA dispatcher can
	        download the U-Boot binary from.
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
	-e|--env-file)
		if [ ! -f "${2}" ]; then
			print_error "For option '${1}' there is no such file: '${2}'"
			print_help
			exit 1
		fi
		ENV_FILE="$(realpath "${2}")"
		shift 2
		;;
	-f|--test-file-dir)
		TEST_FILE_DIR="${2}"
		shift 2
		;;
	-g|--build-job)
		BUILD_JOB_ID="${2}"
		shift 2
		;;
	-i|--lavacli-identity)
		LAVACLI_IDENTITY="${2}"
		shift 2
		;;
	-j|--junit-dir)
		if [ ! -d "${2}" ]; then
			print_error "For option '${1}' there is no such directory: '${2}'"
			print_help
			exit 1
		fi

		if ! command -v yq >/dev/null 2>&1; then
			echo "Ignoring --junit-dir option as yq is not installed."
		else
			JUNIT_DIR="$(realpath "${2}")"
		fi
		shift 2
		;;
	-l|--lava-template)
		if [ ! -f "${2}" ]; then
			print_error "For option '${1}' there is no such file: '${2}'"
			print_help
			exit 1
		fi
		TEMPLATE_FILES+=("$(realpath "${2}")")
		shift 2
		;;
	-s|--submit-only)
		SUBMIT_ONLY=true
		shift
		;;
	-t|--test-definition)
		if [ ! -f "${2}" ]; then
			print_error "For option '${1}' there is no such file: '${2}'"
			print_help
			exit 1
		fi
		TEST_FILES+=("$(realpath "${2}")")
		shift 2
		;;
	-u|--lava-user)
		LAVA_USER="${2}"
		shift 2
		;;
	-B|--base-url)
		BASE_URL="${2}"
		shift 2
		;;
	-Ud|--url-dtb)
		URL_DTB="${2}"
		shift 2
		;;
	-Uk|--url-kernel)
		URL_KERNEL="${2}"
		shift 2
		;;
	-Ur|--url-rootfs)
		URL_ROOTFS="${2}"
		shift 2
		;;
	-Uf|--url-fw)
		URL_FW="${2}"
		shift 2
		;;
	-Ub|--url-bl2)
		URL_BL2="${2}"
		shift 2
		;;
	-Ui|--url-fip)
		URL_FIP="${2}"
		shift 2
		;;
	-U0|--url-sa0)
		URL_SA0="${2}"
		shift 2
		;;
	-U6|--url-sa6)
		URL_SA6="${2}"
		shift 2
		;;
	-U3|--url-bl31)
		URL_BL31="${2}"
		shift 2
		;;
	-Uu|--url-uboot)
		URL_UBOOT="${2}"
		shift 2
		;;
	-h|--help)
		print_help
		exit 0
		;;
	*)
		print_error "Option '${1}' is unknown."
		print_help
		exit 1
		;;
	esac
	done
}

check_mandatory_arguments () {
	print_debug "Entering check_mandatory_arguments()"

	if [ ${#TEMPLATE_FILES[@]} -eq 0 ]; then
		print_error "At least one -l|--lava-template must be provided (can be given multiple times)."
		print_help
		exit 1
	fi

	if [ -z "${ENV_FILE:-}" ]; then
		print_error "Option -e|--env-file must be provided."
		print_help
		exit 1
	fi

	# Count how many URL modes have been provided
	local modes=0
	[ -n "${BUILD_JOB_ID:-}" ] && (( modes++ ))
	[ -n "${BASE_URL:-}" ] && (( modes++ ))
	[ -n "${URL_DTB:-}" ] && (( modes++ ))

	if [ "${modes}" -gt 1 ]; then
		print_error "Options -g|--build-job, -B|--base-url and -Ud/-Uk/-Ur are mutually exclusive. Please provide only one."
		print_help
		exit 1
	fi

	if [ "${modes}" -eq 0 ]; then
		print_error "One of -g|--build-job, -B|--base-url, or -Ud|--url-dtb/-Uk|--url-kernel/-Ur|--url-rootfs must be provided."
		print_help
		exit 1
	fi

	# Mode-specific checks
	if [ -n "${BUILD_JOB_ID:-}" ]; then
		if [ -z "${TEST_FILE_DIR:-}" ]; then
			print_error "Option -f|--test-file-dir must be provided when -g|--build-job is being used."
			print_help
			exit 1
		fi
	fi

	if [ -n "${URL_DTB:-}" ]; then
		if [ -z "${URL_KERNEL:-}" ] || [ -z "${URL_ROOTFS:-}" ]; then
			print_error "When using explicit URLs, all three of -Ud|--url-dtb, -Uk|--url-kernel and -Ur|--url-rootfs must be provided."
			print_help
			exit 1
		fi
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

	if [ -n "${BUILD_JOB_ID+x}" ]; then
		print_debug "BUILD_JOB_ID=${BUILD_JOB_ID}"
	fi
	if [ -n "${TEST_FILE_DIR+x}" ]; then
		print_debug "TEST_FILE_DIR=${TEST_FILE_DIR}"
	fi
	if [ -n "${BASE_URL+x}" ]; then
		print_debug "BASE_URL=${BASE_URL}"
	fi
	print_debug "DEBUG=${DEBUG}"
	print_debug "ENV_FILE=${ENV_FILE:-}"
	if [ -n "${JUNIT_DIR+x}" ]; then
		print_debug "JUNIT_DIR=${JUNIT_DIR}"
	fi
	if [ -n "${LAVA_USER+x}" ]; then
		print_debug "LAVA_USER=${LAVA_USER}"
	fi
	print_debug "LAVACLI_IDENTITY=${LAVACLI_IDENTITY}"
	print_debug "SUBMIT_ONLY=${SUBMIT_ONLY}"
	if [ ${#TEMPLATE_FILES[@]} -gt 0 ]; then
		print_debug "TEMPLATE_FILES=${TEMPLATE_FILES[*]}"
	fi
	if [ -n "${TEST_FILES+x}" ]; then
		print_debug "TEST_FILES=${TEST_FILES[*]}"
	fi
	print_debug "TMP=${TMP}"
	if [ -n "${URL_DTB+x}" ]; then
		print_debug "URL_DTB=${URL_DTB}"
	fi
	if [ -n "${URL_KERNEL+x}" ]; then
		print_debug "URL_KERNEL=${URL_KERNEL}"
	fi
	if [ -n "${URL_ROOTFS+x}" ]; then
		print_debug "URL_ROOTFS=${URL_ROOTFS}"
	fi
	if [ -n "${URL_FW+x}" ]; then
		print_debug "URL_FW=${URL_FW}"
	fi
	if [ -n "${URL_BL2+x}" ]; then
		print_debug "URL_BL2=${URL_BL2}"
	fi
	if [ -n "${URL_FIP+x}" ]; then
		print_debug "URL_FIP=${URL_FIP}"
	fi
	if [ -n "${URL_SA0+x}" ]; then
		print_debug "URL_SA0=${URL_SA0}"
	fi
	if [ -n "${URL_SA6+x}" ]; then
		print_debug "URL_SA6=${URL_SA6}"
	fi
	if [ -n "${URL_BL31+x}" ]; then
		print_debug "URL_BL31=${URL_BL31}"
	fi
	if [ -n "${URL_UBOOT+x}" ]; then
		print_debug "URL_UBOOT=${URL_UBOOT}"
	fi
}

prepare_template () {
	print_debug "Entering prepare_template()"
	echo "Creating LAVA job definition"

	DEFINITION="${TMP}/DEFINITION.yaml"

	# Combine all base templates in the order provided
	: > "${DEFINITION}"  # truncate/create
	for tf in "${TEMPLATE_FILES[@]}"; do
		print_debug "Appending template: ${tf}"
		cat "${tf}" >> "${DEFINITION}"
		# Add a newline separator if the file does not end with one
		tail -c1 "${tf}" | read -r _ || echo >> "${DEFINITION}"
	done

	# Get variables from user provided environment file
	source "${ENV_FILE}"

	# Loop through each line in environment file
	while read -r line; do
		# Get variable name from environment file
		local var=$(echo "${line}" | cut -d "=" -f1)

		# Prepend "PLACEHOLDER_" to variable name and substitute
		# placeholder in definition file with the data from the env file.
		print_debug "Attempting to replace PLACEHOLDER_${var} with \"${!var}\""
		sed -i "s|PLACEHOLDER_${var}\b|${!var}|g" "${DEFINITION}"
	done < "${ENV_FILE}"

	# Insert job definition
	print_debug "Replacing PLACEHOLDER_JOB_NAME with \"RZ Community BSP Testing\""
	sed -i "s|PLACEHOLDER_JOB_NAME|RZ Community BSP Testing|g" "${DEFINITION}"

	# Build the binary URLs depending on which mode was selected
	if [ -n "${BUILD_JOB_ID:-}" ]; then
		# Mode 1: GitLab CI — construct URLs from artifact storage
		print_debug "URL mode: GitLab CI (build job ${BUILD_JOB_ID})"
		local base_url="${CI_PROJECT_URL}/-/jobs/${BUILD_JOB_ID}/artifacts/raw/${TEST_FILE_DIR}"

		URL_DTB="${base_url}/${DTB}"
		URL_KERNEL="${base_url}/${KERNEL}"
		URL_ROOTFS="${base_url}/${ROOTFS}"
		URL_FW="${base_url}/${FW}"
		URL_BL2="${base_url}/${BL2}"
		URL_FIP="${base_url}/${FIP}"
		URL_SA0="${base_url}/${SA0}"
		URL_SA6="${base_url}/${SA6}"
		URL_BL31="${base_url}/${BL31}"
		URL_UBOOT="${base_url}/${UBOOT}"

	elif [ -n "${BASE_URL:-}" ]; then
		# Mode 2: Base URL — combine base URL with filenames from env file
		print_debug "URL mode: Base URL (${BASE_URL})"

		# Strip any trailing slash from base URL for consistency
		local base_url="${BASE_URL%/}"

		URL_DTB="${base_url}/${DTB}"
		URL_KERNEL="${base_url}/${KERNEL}"
		URL_ROOTFS="${base_url}/${ROOTFS}"
		URL_FW="${base_url}/${FW}"
		URL_BL2="${base_url}/${BL2}"
		URL_FIP="${base_url}/${FIP}"
		URL_SA0="${base_url}/${SA0}"
		URL_SA6="${base_url}/${SA6}"
		URL_BL31="${base_url}/${BL31}"
		URL_UBOOT="${base_url}/${UBOOT}"

	else
		# Mode 3: Explicit URLs provided via -Ud/-Uk/-Ur etc.
		print_debug "URL mode: Explicit URLs"
	fi

	declare -A URLS=(
		[PLACEHOLDER_DTB_URL]="${URL_DTB:-}"
		[PLACEHOLDER_KERNEL_URL]="${URL_KERNEL:-}"
		[PLACEHOLDER_ROOTFS_URL]="${URL_ROOTFS:-}"
		[PLACEHOLDER_FW_URL]="${URL_FW:-}"
		[PLACEHOLDER_BL2_URL]="${URL_BL2:-}"
		[PLACEHOLDER_FIP_URL]="${URL_FIP:-}"
		[PLACEHOLDER_SA0_URL]="${URL_SA0:-}"
		[PLACEHOLDER_SA6_URL]="${URL_SA6:-}"
		[PLACEHOLDER_BL31_URL]="${URL_BL31:-}"
		[PLACEHOLDER_UBOOT_URL]="${URL_UBOOT:-}"
	)

	for placeholder in "${!URLS[@]}"; do
		value="${URLS[$placeholder]}"
		if [ -z "${value}" ]; then
			print_debug "Skipping ${placeholder} as value is empty"
			continue
		fi
		if grep -qF -- "$placeholder" "$DEFINITION"; then
			print_debug "Replacing ${placeholder} with \"${value}\""
			sed -i "s|${placeholder}|${value}|g" "$DEFINITION"
		fi
	done

	# Add test definitions
	for test in "${TEST_FILES[@]}"; do
		cat "${test}" >> "${DEFINITION}"
	done

	# Add notification, if a LAVA user has been provided
	if [ -n "${LAVA_USER+x}" ]; then
		print_debug "Adding notify block for \"${LAVA_USER}\""

		cat>>"${DEFINITION}"<<-EOF

		notify:
		  criteria:
		    status: finished
		  verbosity: verbose
		  recipients:
		  - to:
		      method: email
		      user: ${LAVA_USER}
		EOF
	fi

	# Add GitLab pipeline & job information, if running in GitLab
	if [ -n "${GITLAB_CI+x}" ]; then
		cat>>"${DEFINITION}"<<-EOF

		metadata:
		  gitlab.pipeline-url: ${CI_PIPELINE_URL}
		  gitlab.job-url: ${CI_JOB_URL}
		EOF
	fi

	if ${DEBUG}; then
		print_debug "Generated job definition:"
		print_debug "Job definition START"
		cat "${DEFINITION}"
		print_debug "Job definition END"
	fi
}

check_lava_configuration () {
	print_debug "Entering check_lava_configuration()"
	echo "Checking that the LAVA configuration is valid"

	lavacli -i ${LAVACLI_IDENTITY} system whoami > /dev/null
	ret=$?
	if [[ ${ret} -ne 0 ]]; then
		if [[ ${ret} -eq 127 ]]; then
			print_error "lavacli is not installed. Please install."
			exit 1
		else
			print_error "lavacli is not configured correctly. Please check ~/.config/lavacli.yaml."
			exit 1
		fi
	fi
}

check_job_definition_is_valid () {
	print_debug "Entering check_job_definition_is_valid()"
	echo "Validating LAVA job definition"

	lavacli -i ${LAVACLI_IDENTITY} jobs validate "${DEFINITION}"
	local ret=$?
	if [[ ${ret} -ne 0 ]]; then
		print_error "Job definition is not valid"
		exit 1
	fi

	print_debug "Job definition is valid"
}

submit_job () {
	print_debug "Entering submit_job()"
	echo "Submitting LAVA job"

	local lava_job_url=$(lavacli -i ${LAVACLI_IDENTITY} jobs submit "${DEFINITION}" --url)
	local ret=$?
	if [[ ${ret} -ne 0 ]]; then
		print_error "Something went wrong when submitting the LAVA test job"
		exit 1
	fi

	LAVA_JOB_ID=$(echo "${lava_job_url}" | rev | cut -d "/" -f 1 | rev)

	print_debug "Submitted LAVA job ID: ${LAVA_JOB_ID}"
	echo "Submitted LAVA job URL: ${lava_job_url}"
}

wait_for_job_to_complete () {
	print_debug "Entering wait_for_job_to_complete()"
	echo "Waiting for LAVA job to complete"

	# Sometimes lavacli may lose connection with the LAVA server so we need
	# to put the check in a loop until it is successful. That said, let's
	# not be stuck in a loop forever...
	for count in {1..10}; do
		lavacli -i ${LAVACLI_IDENTITY} jobs wait "${LAVA_JOB_ID}"
		local ret=$?
		if [[ ${ret} -eq 0 ]]; then
			print_debug "LAVA job ${LAVA_JOB_ID} is complete"
			break
		else
			if [[ ${count} -eq 10 ]]; then
				print_error "A lot of problems trying to use \"lavacli jobs wait\". Give up."
				exit 1
			else
				print_debug "Something went wrong whilst waiting for LAVA job ${LAVA_JOB_ID} to complete. Try again..."
			fi
		fi
	done
}

save_junit_results () {
	print_debug "Entering save_junit_results()"

	local lava_config_file="${HOME}/.config/lavacli.yaml"
	local lava_api_url=$(yq -r ".\"${LAVACLI_IDENTITY}\".uri" "${lava_config_file}" | \
			sed 's|RPC2|api/v0.2|g')

	local junit_results_file="${JUNIT_DIR}/results_${LAVA_JOB_ID}.xml"
	curl -s -o "${junit_results_file}" "${lava_api_url}"/jobs/"${LAVA_JOB_ID}"/junit/
	local ret=$?
	if [[ ${ret} -ne 0 ]]; then
		print_error "Error downloading junit test results from LAVA"
		exit 1
	fi

	# Strip out the results from the lava test suite
	sed -i '/<testsuite[^>]*name="lava"/,/<\/testsuite>/d' "${junit_results_file}"
}

get_results () {
	print_debug "Entering get_results()"
	echo "Getting LAVA test job results"

	lavacli -i ${LAVACLI_IDENTITY} results "${LAVA_JOB_ID}"
	local ret=$?
	if [[ ${ret} -ne 0 ]]; then
		print_error "Error obtaining LAVA test results"
		exit 1
	fi

	if [ -n "${JUNIT_DIR:-}" ]; then
		save_junit_results
	fi
}

get_job_result () {
	print_debug "Entering get_job_result()"
	echo "Getting overall LAVA test job result"

	local lavacli_output="${TMP}"/lavacli_output
	lavacli -i ${LAVACLI_IDENTITY} jobs show "${LAVA_JOB_ID}" > "${lavacli_output}"
	local ret=$?
	if [[ ${ret} -ne 0 ]]; then
		print_error "Error obtaining LAVA job results"
		exit 1
	fi

	local health=$(grep "Health" "${lavacli_output}" \
		| cut -d ":" -f 2 \
		| awk '{$1=$1};1')

	if [ "${health}" != "Complete" ]; then
		JOB_RESULT="FAIL"
	else
		JOB_RESULT="PASS"
	fi
}

# After calling setup below we now care about cleaning up after ourselves
trap 'cleanup' EXIT INT TERM ABRT QUIT

# Create TMP directory
setup

# Parse command line arguments
parse_options "$@"

# Check mandatory arguments have been set
check_mandatory_arguments

# Check that lavacli is working
check_lava_configuration

# Print value of each of the variables
debug_print_variables

# Prepare the LAVA job definition
prepare_template

# Validate LAVA job definition
check_job_definition_is_valid

# Submit job definition to LAVA
submit_job

if ! ${SUBMIT_ONLY}; then
	# Wait for the submitted job to complete
	wait_for_job_to_complete

	# Extract the test results from LAVA
	get_results

	# Check that LAVA job PASSED, and return fail if not
	get_job_result
	if [ "${JOB_RESULT}" != "PASS" ]; then
		print_error "The LAVA test job did not complete."
		exit 1
	else
		echo "LAVA test job completed!"
	fi
fi

echo "DONE!"
