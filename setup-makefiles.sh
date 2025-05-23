#!/bin/bash
#
# Copyright (C) 2017-2020 The LineageOS Project
# Copyright (C) 2020 The AOSPA Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

INITIAL_COPYRIGHT_YEAR=2020

MIUICAMERA_COMMON=common
VENDOR=miuicamera

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

ROOT="$MY_DIR/../.."

HELPER="${ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

function vendor_imports() {
    cat <<EOF >>"$1"
		"vendor/xiaomi/laurel_sprout",
EOF
}

function lib_to_package_fixup_vendor_variants() {
    case "$1" in
        libmpbase | \
        libOpenCL)
            echo "$1_system"
            ;;
        *)
            return 1
            ;;
    esac
}

function lib_to_package_fixup() {
    lib_to_package_fixup_clang_rt_ubsan_standalone "$1" ||
    lib_to_package_fixup_proto_3_9_1 "$1" ||
    lib_to_package_fixup_vendor_variants "$@"
}

# Initialize the helper
setup_vendor "$MIUICAMERA_COMMON" "$VENDOR" "$ROOT" true

# Copyright headers and guards
write_headers "xiaomi"
sed -i 's|TARGET_DEVICE|BOARD_VENDOR|g' common/Android.mk
sed -i 's|vendor/miuicamera/|vendor/miuicamera/common|g' $PRODUCTMK
sed -i 's|device/miuicamera//setup-makefiles.sh|vendor/miuicamera/setup-makefiles.sh|g' $ANDROIDBP $ANDROIDMK $BOARDMK $PRODUCTMK

write_makefiles "$MY_DIR"/proprietary-files.txt true

# Finish
write_footers
