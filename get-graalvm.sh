#!/usr/bin/env bash
#
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
#
# The Universal Permissive License (UPL), Version 1.0
#
# Subject to the condition set forth below, permission is hereby granted to any
# person obtaining a copy of this software, associated documentation and/or
# data (collectively the "Software"), free of charge and under any and all
# copyright rights in the Software, and any and all patent rights owned or
# freely licensable by each licensor hereunder covering either (i) the
# unmodified Software as contributed to or provided by such licensor, or (ii)
# the Larger Works (as defined below), to deal in both
#
# (a) the Software, and
#
# (b) any piece of software and/or hardware listed in the lrgrwrks.txt file if
# one is included with the Software each a "Larger Work" to which the Software
# is contributed by such licensors),
#
# without restriction, including without limitation the rights to copy, create
# derivative works of, display, perform, and distribute the Software and make,
# use, sell, offer for sale, import, export, have made, and have sold the
# Software and the Larger Work(s), and to sublicense the foregoing rights on
# either these or other terms.
#
# This license is subject to the following condition:
#
# The above copyright notice and either this complete permission notice or at a
# minimum a reference to the UPL must be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

set -o errexit # fail on error
set -o nounset # fail if a variable is undefined
readonly GVMD_VERSION="1.0.0"
readonly GVMD_NAME="GraalVM JDK Downloader"
readonly GVMD_SCRIPT="jdk"
readonly DEFAULT_CE_IDENTIFIER="graalvm-ce-java17-22.3.1"
readonly DEFAULT_EE_IDENTIFIER="graalvm-ee-java17-22.3.1"
readonly GU_CONFIG="${HOME}/.gu/config"

###########
# Helpers #
###########

function fail() {
    echo "$1"
    exit 1
}

function print_help() {
  cat <<EOF
${GVMD_NAME} v${GVMD_VERSION}

Usage:
  bash <(curl -sL https://get.graalvm.org/${GVMD_SCRIPT}) [opts] [${DEFAULT_CE_IDENTIFIER}]

Options:
  -c | --components   Comma-separated list of GraalVM components (for example,
                      '-c python,nodejs').
  -d | --debug        Enable debug mode.
  -h | --help         Show this help text.
  --no-progress       Disable progress printing.
  --to                Existing path to where artifacts will be downloaded (for example,
                      '--to "\$HOME"'; current directory is the default).

Visit https://github.com/graalvm/graalvm-jdk-downloader for more information.
EOF
}

function print_epilog() {
    if [[ -n "${SDKMAN_VERSION:-}" ]]; then
        cat <<EOF

If you like to manage this GraalVM JDK installation with SDKMAN! (see https://sdkman.io/usage#localversion for more info), run:
$ sdk install java ${GRAALVM_VERSION:0:6}.r${JAVA_VERSION:4:2}-grl${GRAALVM_EDITION:0:1} "${GRAALVM_HOME}"
EOF
    fi

    cat <<EOF

Run the following to adjust your \$JAVA_HOME and/or \$PATH:
$ export PATH="${GRAALVM_HOME}/bin:\$PATH"
$ export JAVA_HOME="${GRAALVM_HOME}"
EOF
}

readonly REPORT_ISSUES_NOTE="Please file an issue at https://github.com/graalvm/graalvm-jdk-downloader/issues."

#############################
# Check and parse arguments #
#############################

opt_components=("native-image")
opt_graalvm_identifier=""
opt_no_progress="${CI:-false}"
opt_positional=()
opt_target_path="$(pwd)"

while [[ $# -gt 0 ]]; do
    case "$1" in
    -c | --components)
        if [[ -z "${2:-}" || "${2:-}" == *" "* ]]; then
            fail "--components arguments must be a comma-separated list of GraalVM components and must not contain a space, got: '${2:-}'."
        fi
        IFS=',' read -r -a opt_user_components <<< "${2:-}"
        opt_components+=("${opt_user_components[@]}")
        shift 2
        ;;
    -d | --debug)
        set -x
        shift
        ;;
    -h | --help)
        print_help
        exit 0
        ;;
    --to)
        opt_target_path="${2:-}"
        if [[ -z "${opt_target_path}" || ! -d "${opt_target_path}" ]]; then
            fail "--to argument must be an existing path, got: '${opt_target_path}'."
        fi
        shift 2
        ;;
    --no-progress)
        opt_no_progress="true"
        shift
        ;;
    -*)
        fail "Unknown option: $1"
        ;;
    *)
        opt_positional+=("$1")
        shift
        ;;
    esac
done

if [[ "${#opt_positional[@]}" -eq 0 ]]; then
    if [[ -n "${GRAAL_EE_DOWNLOAD_TOKEN:-}" || -f "${GU_CONFIG}" ]]; then
        opt_graalvm_identifier="${DEFAULT_EE_IDENTIFIER}"
    else
        opt_graalvm_identifier="${DEFAULT_CE_IDENTIFIER}"
    fi
elif [[ "${#opt_positional[@]}" -ne 1 || "${opt_positional[0]}" != "graalvm-"* ]]; then
    fail "A GraalVM identifier (for example, 'graalvm-ce-java11-22.1.0') must be the only position argument, got ${#opt_positional[@]}: '${opt_positional[*]:-}'."
else
    opt_graalvm_identifier="${opt_positional[0]}"
fi

parts="${opt_graalvm_identifier#*-}"
readonly GRAALVM_EDITION="${parts%%-*}"
case "${GRAALVM_EDITION}" in
    "ce"|"ee") ;;
    *)
        fail "Unsupported GraalVM Edition: ${GRAALVM_EDITION} (use 'ce' or 'ee')."
esac

parts="${parts#*-}"
readonly JAVA_VERSION="${parts%%-*}"
case "${JAVA_VERSION}" in
    "java11"|"java17"|"java19") ;;
    "${GRAALVM_EDITION}")
        fail "GraalVM identifier '${opt_graalvm_identifier}' is missing a Java version (for example, '-java17')."
        ;;
    *)
        fail "Unsupported Java version: ${JAVA_VERSION} (use 'java11', 'java17', or 'java19')."
esac

GRAALVM_HOME_SUFFIX=""
GRAALVM_GU_EXEC="gu"
GRAALVM_FILENAME_EXT="tar.gz"
case "$(uname -s)" in
    "Linux")
        GRAALVM_OS="linux";;
    "Darwin")
        GRAALVM_HOME_SUFFIX="/Contents/Home"
        GRAALVM_OS="darwin";;
    "CYGWIN_NT-"*)
        GRAALVM_GU_EXEC="gu.cmd"
        GRAALVM_FILENAME_EXT="zip"
        GRAALVM_OS="windows";;
    "MINGW64_NT-"*)
        GRAALVM_GU_EXEC="gu.cmd"
        GRAALVM_FILENAME_EXT="zip"
        GRAALVM_OS="windows";;
    *)
        fail "Unsupported OS: $(uname -s)"
esac
readonly GRAALVM_OS GRAALVM_HOME_SUFFIX GRAALVM_GU_EXEC GRAALVM_FILENAME_EXT

case "$(uname -m)" in
    "x86_64")
        GRAALVM_ARCH="amd64"
        ;;
    "aarch64"|"arm64")
        GRAALVM_ARCH="aarch64"
        ;;
    *)
        fail "Unsupported architecture: $(uname -m)"
esac
readonly GRAALVM_ARCH

parts="${parts#*-}"
readonly GRAALVM_VERSION="${parts%%-*}"

if [[ "${GRAALVM_VERSION}" == "${JAVA_VERSION}" ]]; then
    fail "GraalVM identifier '${opt_graalvm_identifier}' is missing a GraalVM version (for example, '-22.1.0')."
elif [[ ! "${GRAALVM_VERSION}" =~ ^[0-9\.]*$ ]]; then
    fail "Invalid GraalVM version: ${GRAALVM_VERSION}"
fi

GRAALVM_IDENTIFIER="graalvm-${GRAALVM_EDITION}-${JAVA_VERSION}-${GRAALVM_OS}-${GRAALVM_ARCH}-${GRAALVM_VERSION}"
GRAALVM_NAME="graalvm-${GRAALVM_EDITION}-${JAVA_VERSION}-${GRAALVM_VERSION}"
GRAALVM_FILENAME="${GRAALVM_IDENTIFIER}.${GRAALVM_FILENAME_EXT}"
TEMP_DL_FILE="$(mktemp)"
readonly GRAALVM_IDENTIFIER GRAALVM_NAME GRAALVM_FILENAME TEMP_DL_FILE

################
# Housekeeping #
################

function ensure_command() {
    local cmd=$1
    if ! command -v "${cmd}" > /dev/null; then
        cat <<EOF
${cmd} not found.

Please install '${cmd}' on your system and restart.
EOF
        fail ""
    fi
}

ensure_command "curl"
if [[ "${GRAALVM_OS}" == "windows" ]]; then
    ensure_command "unzip"
else
    ensure_command "tar"
fi

readonly GVMD_USER_AGENT="${GVMD_NAME}/${GVMD_VERSION} (arch:${GRAALVM_ARCH}; os:${GRAALVM_OS}; java:${JAVA_VERSION})"

curl_args=("--show-error" "--fail" "--location" "--user-agent" "${GVMD_USER_AGENT}")
gu_args=("--non-interactive")

if [[ "${opt_no_progress}" == "true" ]]; then
    curl_args+=("--silent")
    gu_args+=("--no-progress")
fi

####################
# Set up directory #
####################

readonly GVMD_DIR="${opt_target_path}" # opt_target_path can only be an existing path
readonly GRAALVM_HOME="${GVMD_DIR}/${GRAALVM_NAME}${GRAALVM_HOME_SUFFIX}"

if [[ -d "${GRAALVM_HOME}" ]]; then
    printf "\nGraalVM JDK (%s) already exists in the target destination!\n" "${GRAALVM_NAME}"
    print_epilog
    exit 0
fi

pushd "${GVMD_DIR}" > /dev/null

############
# Download #
############

case "${GRAALVM_EDITION}" in
    "ce")
        readonly GRAALVM_CE_BASE="https://github.com/graalvm/graalvm-ce-builds/releases/download"

        echo "Downloading ${GRAALVM_FILENAME}..."
        dl_url="${GRAALVM_CE_BASE}/vm-${GRAALVM_VERSION}/${GRAALVM_IDENTIFIER}.${GRAALVM_FILENAME_EXT}"
        curl "${curl_args[@]}" -o "${TEMP_DL_FILE}" "${dl_url}" || fail "Failed to download '${dl_url}'."

        checksum_file="$(mktemp)"
        curl "${curl_args[@]}" --silent -o "${checksum_file}" "${dl_url}.sha256" || fail "Failed to download '${dl_url}.sha256'. ${REPORT_ISSUES_NOTE}"
        GRAALVM_FILENAME_CHECKSUM="$(cat "${checksum_file}")"
        readonly GRAALVM_FILENAME_CHECKSUM
        rm "${checksum_file}"
        ;;
    "ee")
        readonly GDS_BASE="https://gds.oracle.com/api/20220101"
        readonly PRODUCT_ID="D53FAE8052773FFAE0530F15000AA6C6"

        if [[ -z "${GRAAL_EE_DOWNLOAD_TOKEN:-}" ]]; then
            if [[ -f "${GU_CONFIG}" ]]; then
                # shellcheck source=/dev/null
                source "${GU_CONFIG}"
                if [[ -z "${GRAAL_EE_DOWNLOAD_TOKEN:-}" ]]; then
                    fail "Unable to detect \$GRAAL_EE_DOWNLOAD_TOKEN in ${GU_CONFIG}."
                fi
            else
                fail "Unable to find a download token. Please provide it via \$GRAAL_EE_DOWNLOAD_TOKEN or run the following script to set one up:
  
$ bash <(curl -sL https://get.graalvm.org/ee-token)
"
            fi
        fi

        filters="productId=${PRODUCT_ID}&metadata=version:${GRAALVM_VERSION}&metadata=isBase:True&status=PUBLISHED&responseFields=id&responseFields=checksum&responseFields=displayName"
        gds_java="${JAVA_VERSION#java}"
        filters="${filters}&metadata=java:jdk${gds_java}"
        gds_os="${GRAALVM_OS}"
        if [[ "${gds_os}" == "darwin" ]]; then
            gds_os="macos" # GDS uses 'macos' instead of 'darwin'
        fi
        filters="${filters}&metadata=os:${gds_os}&metadata=arch:${GRAALVM_ARCH}"

        echo "Fetching artifact metadata for ${GRAALVM_IDENTIFIER}..."
        artifacts_response=$(curl "${curl_args[@]}" --silent -X GET "${GDS_BASE}/artifacts?${filters}") || fail "Unable to find '${GRAALVM_IDENTIFIER}'."
        artifact_id=$(echo "$artifacts_response" | grep -o '"id":"[^"]*' | grep -o '[^"]*$') || fail "Unable to find artifact id."
        GRAALVM_FILENAME_CHECKSUM=$(echo "$artifacts_response" | grep -o '"checksum":"[^"]*' | grep -o '[^"]*$') || fail "Unable to find artifact checksum."
        readonly GRAALVM_FILENAME_CHECKSUM

        echo "Downloading ${GRAALVM_FILENAME}..."
        curl "${curl_args[@]}" -H "x-download-token: ${GRAAL_EE_DOWNLOAD_TOKEN}" \
             -o "${TEMP_DL_FILE}" -X GET "${GDS_BASE}/artifacts/${artifact_id}/content" || fail "
Failed to download '${GRAALVM_FILENAME}'.

Ensure your download token is activated by accepting the license agreement sent via email."
        ;;
    *)
        fail "Unsupported GraalVM Edition: ${GRAALVM_EDITION} (use 'ce' or 'ee')."
esac

###########
# Verify  #
###########

shasum_exec=""
if command -v "sha256sum" > /dev/null; then
    shasum_exec="sha256sum"
elif command -v "shasum" > /dev/null; then
    shasum_exec="shasum --algorithm 256"
fi

if [[ -n "${shasum_exec}" ]]; then
    echo "Verifying checksum..."
    if ! echo "${GRAALVM_FILENAME_CHECKSUM}  ${TEMP_DL_FILE}" | ${shasum_exec} --check --status -; then
        fail "Failed to verify checksum. ${REPORT_ISSUES_NOTE}"
    fi
else
    echo "Skipping checksum verification ('sha256sum' and 'shasum' not found)..."
fi

###########
# Extract #
###########

echo "Extracting..."
if [[ "${GRAALVM_OS}" == "windows" ]]; then
    unzip -q "${TEMP_DL_FILE}"
else
    tar xzf "${TEMP_DL_FILE}"
fi
rm "${TEMP_DL_FILE}"

if [[ ! -d "${GRAALVM_HOME}" ]]; then
    fail "Failed to find GraalVM installation. ${REPORT_ISSUES_NOTE}"
fi

popd > /dev/null

##############################
# Install GraalVM components #
##############################

if [[ "${#opt_components[@]}" -gt 0 ]]; then
    echo "Installing GraalVM components..."
    "${GRAALVM_HOME}/bin/${GRAALVM_GU_EXEC}" install "${gu_args[@]}" "${opt_components[@]}"

    if [[ ${opt_components[*]} == *"native-image"*  ]]; then
        cat <<EOF

+------------------------------------------------------------------------------+
| Prerequisites for GraalVM Native Image                                       |
+------------------------------------------------------------------------------+
EOF
        if [[ "${GRAALVM_OS}" == "linux" ]]; then
            cat <<EOF
| On Oracle Linux, use the YUM package manager:                                |
| $ sudo yum install gcc glibc-devel zlib-devel                                |
|                                                                              |
| Some Linux distributions may additionally require libstdc++-static.          |
| You can install libstdc++-static if the optional repositories are enabled    |
| ('ol7_optional_latest' on Oracle Linux 7 and 'ol8_codeready_builder' on      |
|  Oracle Linux 8).                                                            |
|                                                                              |
| On Ubuntu, use the 'apt-get' package manager:                                |
| $ sudo apt-get install build-essential libz-dev zlib1g-dev                   |
|                                                                              |
| On other Linux distributions, use the DNF package manager:                   |
| $ sudo dnf install gcc glibc-devel zlib-devel libstdc++-static               |
EOF
        elif [[ "${GRAALVM_OS}" == "darwin" ]]; then
            cat <<EOF
| If you are using macOS Catalina and later you may need to remove the         |
| quarantine attribute before use:                                             |
| $ sudo xattr -r -d com.apple.quarantine "${GRAALVM_HOME}" |
|                                                                              |
| Please also ensure Xcode is installed:                                       |
| $ xcode-select --install                                                     |
EOF
        elif [[ "${GRAALVM_OS}" == "windows" ]]; then
              cat <<EOF
| To use Native Image on Windows, install Visual Studio and Microsoft Visual   |
| C++ (MSVC).                                                                  |
| There are two installation options:                                          |
|   * Install the Visual Studio Build Tools with the Windows 10 SDK            |
|   * Install Visual Studio with the Windows 10 SDK                            |
|                                                                              |
| You can use Visual Studio 2017 version 15.9 or later.                        |
|                                                                              |
| The 'native-image' tool will only work when it is run from an 'x64 Native    |
| Tools Command Prompt'. The command for initiating an x64 Native Tools        |
| command prompt varies according to whether you only have the Visual Studio   |
| Build Tools installed or if you have the full Visual Studio 2019 installed.  |
EOF
        else
            echo "Unexpected OS: ${GRAALVM_OS}"
        fi
        cat <<EOF
+------------------------------------------------------------------------------+
EOF
    fi
fi

############
# Teardown #
############


printf "\nGraalVM JDK (%s) has been downloaded successfully!\n" "${GRAALVM_NAME}"
print_epilog
