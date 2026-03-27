# Capture THISDIR immediately - it is only valid during parsing of this file.
# FILESEXTRAPATHS itself uses deferred expansion so that BPN and PV resolve to
# the actual recipe values (e.g. u-boot/2026.01) rather than BitBake defaults.
MENDER_RPI_UBOOT_DIR := "${THISDIR}"
FILESEXTRAPATHS:prepend:rpi = "${MENDER_RPI_UBOOT_DIR}/${BPN}-${PV}:${MENDER_RPI_UBOOT_DIR}/patches:"

BOOTENV_SIZE:rpi ?= "0x4000"

# U-Boot auto-configuration doesn't work properly for Raspberry Pi, due to its
# use of boot.scr and cmdline.txt.
MENDER_UBOOT_AUTO_CONFIGURE:rpi = "0"

# Apply the patch from meta-raspberrypi to all Raspberry Pi models and versions
SRC_URI:append:rpi = " file://maxsize.cfg"

SRC_URI:append:rpi:mender-uboot = "${@bb.utils.contains('MENDER_UBOOT_AUTO_CONFIGURE', \
                                                        '1', \
                                                        '', \
                                                        ' file://0001-configs-rpi-enable-mender-requirements.patch \
                                                          file://0001-pci-fdt-ignore-checks-for-address-range.patch \
                                                        ', \
                                                        d)}"
