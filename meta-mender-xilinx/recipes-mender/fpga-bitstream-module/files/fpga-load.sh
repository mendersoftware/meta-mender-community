#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# fpga-load.sh - program the Zynq-7000 PL from /data/fpga via the kernel
# fpga_manager sysfs interface.
# Usage: fpga-load.sh [bitstream-filename-in-/data/fpga]
set -eu

FPGA_MGR="/sys/class/fpga_manager/fpga0"
FW_DIR="/data/fpga"
FW_NAME="${1:-current.bit.bin}"
FW_PATH_PARAM="/sys/module/firmware_class/parameters/path"

err() { echo "fpga-load: $1" >&2; }

[ -d "$FPGA_MGR" ] || { err "no FPGA manager at $FPGA_MGR"; exit 1; }
[ -f "$FW_DIR/$FW_NAME" ] || { err "no bitstream at $FW_DIR/$FW_NAME"; exit 1; }
[ -w "$FW_PATH_PARAM" ] || { err "$FW_PATH_PARAM not writable"; exit 1; }

# The firmware search path is global kernel state, and this script can be
# invoked concurrently (boot service vs. update module): serialize.
exec 9> /run/fpga-load.lock
flock 9

# Point the kernel firmware search path at /data/fpga for the duration of
# the load, then restore it. This keeps bitstreams entirely on the data
# partition - the rootfs stays untouched. The param cannot be cleared back
# to empty through sysfs (zero-byte writes never reach the kernel's param
# store), so an originally empty value is restored as /lib/firmware, the
# head of the default search order.
saved_path=$(tr -d '\n' < "$FW_PATH_PARAM")
[ -n "$saved_path" ] || saved_path="/lib/firmware"
restore_path() { printf '%s' "$saved_path" > "$FW_PATH_PARAM" 2>/dev/null || true; }
trap restore_path EXIT

printf '%s' "$FW_DIR" > "$FW_PATH_PARAM"
printf '0' > "$FPGA_MGR/flags"                  # 0 = full reconfiguration
if ! printf '%s' "$FW_NAME" > "$FPGA_MGR/firmware"; then
    err "programming failed (write to $FPGA_MGR/firmware)"
    exit 1
fi

state=$(cat "$FPGA_MGR/state")
if [ "$state" != "operating" ]; then
    err "unexpected FPGA state after programming: $state"
    exit 1
fi
err "PL programmed with $FW_DIR/$FW_NAME (state: operating)"
exit 0
