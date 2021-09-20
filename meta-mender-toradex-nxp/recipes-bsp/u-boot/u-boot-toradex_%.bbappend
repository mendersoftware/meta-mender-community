FILESEXTRAPATHS_prepend_mender-uboot := "${THISDIR}/files:"

require recipes-bsp/u-boot/u-boot-mender.inc

MENDER_UBOOT_AUTO_CONFIGURE_mender-uboot = "0"
BOOTENV_SIZE_mender-uboot = "0x4000"
MENDER_RESERVED_SPACE_BOOTLOADER_DATA_mender-uboot_colibri-imx6ull ="0x40000"
BOOTENV_SIZE_mender-uboot_colibri-imx6ull = "0x20000"

RPROVIDES_${PN} += "u-boot"
PROVIDES += "u-boot-default-env"

# Apply custom patches for Toradex u-boot
SRC_URI_append_mender-uboot = " \
    file://0001-configs-toradex-board-specific-mender-integration.patch \
"

