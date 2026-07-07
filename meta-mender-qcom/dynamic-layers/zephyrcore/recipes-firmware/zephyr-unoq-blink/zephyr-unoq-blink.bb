SUMMARY = "Uno Q MCU demo: versioned LED blink (Zephyr) for the STM32U585"
DESCRIPTION = "A minimal Zephyr application for the Arduino Uno Q's on-board \
STM32U585 (Cortex-M33) MCU. Blinks led0 at a version-dependent rate and embeds \
a version marker in .rodata (readable over SWD) so the Mender zephyr-mcu update \
module can verify the running firmware. Built in the 'mcu' multiconfig."

# zephyr-sample -> zephyr-image.inc -> zephyr-kernel-src.inc, which sets
# LICENSE = "Apache-2.0" + LIC_FILES_CHKSUM (the fetched Zephyr LICENSE); our
# app source is Apache-2.0 too, so we do not override them.
inherit zephyr-sample

COMPATIBLE_MACHINE = "arduino-uno-q"

# Out-of-tree Zephyr app shipped with the recipe. It unpacks to ${UNPACKDIR}/app
# alongside the fetched Zephyr tree (ZEPHYR_BASE = ${S}/zephyr).
SRC_URI += "file://app"
ZEPHYR_SRC_DIR = "${UNPACKDIR}/app"

# Demo version + blink period, injected into the app build. Bump for v2.
FW_VERSION ?= "unoq-mcu-v1"
BLINK_PERIOD_MS ?= "500"
EXTRA_OECMAKE:append = " -DFW_VERSION=${FW_VERSION} -DBLINK_PERIOD_MS=${BLINK_PERIOD_MS}"

# Produce the .hex (used for flashing) in addition to .elf/.bin; the class
# default omits .hex.
ZEPHYR_MAKE_OUTPUT = "zephyr.elf zephyr.bin zephyr.hex"
