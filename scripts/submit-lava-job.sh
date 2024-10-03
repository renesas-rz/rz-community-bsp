#!/bin/bash
#SPDX-License-Identifier: MIT

# This script assumes that lavacli is already installed and that the
# ~/.config/lavacli.yml file has been configured correctly.

set -uo pipefail

SCRIPT_NAME="$0"

# Set variable defaults
DEBUG=false
SUBMIT_ONLY=false

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
		[-f DIR] [-g JOB_ID] [-j <DIR>] [-s] [-t <TEST_DEFINITION>] \\
		[-u <USER>] [-Ud DTB_URL] -[Uk KERNEL_URL] [-Ur ROOTFS_URL] \\
		[-d] [-h] \\
		-b <BASE_TEMPLATE> -e <ENV>

	OPTIONS:
	-b, --base-template <BASE_TEMPLATE>
		Use this template file as the base for the LAVA job definition.
		This script will replace PLACEHOLDER variables in the template
		file with the corresponding values from the env file provided
		by the -e option.
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
		If this option is provided the URL locations for the DTB, kernel
		and rootfs binaries will be calculated automatically.
		If this option is provided -Ud, -Uk and -Ur will be ignored.
		If this option is not provided -Ud, -Uk and -Ur must be provided
		instead.
	-j, --junit-dir <DIR>
		Save the LAVA test results in junit format to a file in the
		specified directory. The file will be called
		"results_<lava-job-number>.xml".
		If this argument is not provided or --submit-only is set, the
		test restuls will not be saved to a file.
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
	-h, --help
		Print this help and exit.

EOF
}

parse_options () {
	print_debug "Entering parse_options()"

	while [[ $# -gt 0 ]]; do
	case $1 in
	-b|--base-template)
		if [ ! -f "${2}" ]; then
			print_error "For option '${1}' there is no such file: '${2}'"
			print_help
			exit 1
		fi
		TEMPLATE_FILE="$(realpath "${2}")"
		shift 2
		;;
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
	-j|--junit-dir)
		if [ ! -d "${2}" ]; then
			print_error "For option '${1}' there is no such directory: '${2}'"
			print_help
			exit 1
		fi
		JUNIT_DIR="$(realpath "${2}")"
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

	if [ -z "${TEMPLATE_FILE}" ]; then
		print_error "Option -b|--base-template must be provided."
		print_help
		exit 1
	fi

	if [ -z "${ENV_FILE}" ]; then
		print_error "Option -e|--env-file must be provided."
		print_help
		exit 1
	fi

	if [ -z "${BUILD_JOB_ID}" ]; then
		if [ -z "${URL_DTB}" ] || [ -z "${URL_KERNEL}" ] || [ -z "${URL_ROOTFS}" ]; then
			print_error "Either option -g|--build-job, or all three of -Ud|--url-dtb, -Uk|--url-kernel and -Ur|--url-rootfs must be provided."
			print_help
			exit 1
		fi

		if [ -z "${TEST_FILE_DIR}" ]; then
			print_error "Option -f|--test-file-dir must be provided when -g|--build-job is being used."
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
	print_debug "DEBUG=${DEBUG}"
	print_debug "ENV_FILE=${ENV_FILE}"
	if [ -n "${JUNIT_DIR+x}" ]; then
		print_debug "JUNIT_DIR=${JUNIT_DIR}"
	fi
	if [ -n "${LAVA_USER+x}" ]; then
		print_debug "LAVA_USER=${LAVA_USER}"
	fi
	print_debug "SUBMIT_ONLY=${SUBMIT_ONLY}"
	print_debug "TEMPLATE_FILE=${TEMPLATE_FILE}"
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
}

prepare_template () {
	print_debug "Entering prepare_template()"
	echo "Creating LAVA job definition"

	DEFINITION="${TMP}/DEFINITION.yaml"
	cat "${TEMPLATE_FILE}" > "${DEFINITION}"

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

	# Inset job definition
	print_debug "Replacing PLACEHOLDER_JOB_NAME with \"RZ Community BSP Testing\""
	sed -i "s|PLACEHOLDER_JOB_NAME|RZ Community BSP Testing|g" "${DEFINITION}"

	# Add the binary URLs
	if [ -n "${BUILD_JOB_ID}" ]; then
		# Binaries are stored in GitLab CI artifact storage
		local base_url="${CI_PROJECT_URL}/-/jobs/${BUILD_JOB_ID}/artifacts/raw/${TEST_FILE_DIR}"

		URL_DTB=${base_url}/"${DTB}"
		URL_KERNEL=${base_url}/"${KERNEL}"
		URL_ROOTFS=${base_url}/"${ROOTFS}"
	fi

	print_debug "Replacing PLACEHOLDER_DTB_URL with \"${URL_DTB}\""
	sed -i "s|PLACEHOLDER_DTB_URL|${URL_DTB}|g" "${DEFINITION}"

	print_debug "Replacing PLACEHOLDER_KERNEL_URL with \"${URL_KERNEL}\""
	sed -i "s|PLACEHOLDER_KERNEL_URL|${URL_KERNEL}|g" "${DEFINITION}"

	print_debug "Replacing PLACEHOLDER_ROOTFS_URL with \"${URL_ROOTFS}\""
	sed -i "s|PLACEHOLDER_ROOTFS_URL|${URL_ROOTFS}|g" "${DEFINITION}"

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

	# Check that the lavacli configuration is valid
	lavacli system whoami > /dev/null
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

	lavacli jobs validate "${DEFINITION}"
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

	local lava_job_url=$(lavacli jobs submit "${DEFINITION}" --url)
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
		lavacli jobs wait "${LAVA_JOB_ID}"
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
	local lava_api_url=$(grep uri "${lava_config_file}" | \
			cut -d " " -f 4 | \
			sed 's|RPC2|api/v0.2|g')

	curl -s -o "${JUNIT_DIR}"/results_"${LAVA_JOB_ID}".xml "${lava_api_url}"/jobs/"${LAVA_JOB_ID}"/junit/
	local ret=$?
	if [[ ${ret} -ne 0 ]]; then
		print_error "Error downloading junit test results from LAVA"
		exit 1
	fi
}

get_results () {
	print_debug "Entering get_results()"
	echo "Getting LAVA test job results"

	lavacli results "${LAVA_JOB_ID}"
	local ret=$?
	if [[ ${ret} -ne 0 ]]; then
		print_error "Error obtaining LAVA test results"
		exit 1
	fi

	if [ -n "${JUNIT_DIR}" ]; then
		save_junit_results
	fi
}

get_job_result () {
	print_debug "Entering get_job_result()"
	echo "Getting overall LAVA test job result"

	local lavacli_output="${TMP}"/lavacli_output
	lavacli jobs show "${LAVA_JOB_ID}" > "${lavacli_output}"
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

# Check manditory arguments have been set
check_manditory_arguments

# Check that lavalcli is working
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
