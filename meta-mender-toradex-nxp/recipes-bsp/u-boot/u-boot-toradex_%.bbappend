FILESEXTRAPATHS_prepend_mender-uboot := "${THISDIR}/files:"

require recipes-bsp/u-boot/u-boot-mender.inc

SRC_URI_append_mender-uboot_verdin-imx8mm = " file://0001-configs-verdin-imx8mm-mender-integration.patch"

MENDER_UBOOT_AUTO_CONFIGURE_mender-uboot = "0"
BOOTENV_SIZE_mender-uboot = "0x2000"
MENDER_RESERVED_SPACE_BOOTLOADER_DATA_mender-uboot_colibri-imx6ull ="0x40000"
BOOTENV_SIZE_mender-uboot_colibri-imx6ull = "0x20000"

RPROVIDES_${PN} += "u-boot"


# Original mender patch cannot be applied directly to toradex u-boot so remove it.
SRC_URI_remove_mender-uboot = " \
    file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
"

# Apply custom generic patch for toradex u-boot
SRC_URI_append_mender-uboot = " \
    file://0001-Integration-of-Mender-boot-code-into-toradex-U-Boot.patch \
"

# Specific settings for toradex colibri-imx6ull module
SRC_URI_append_mender-uboot_colibri-imx6ull = " \
	file://0001-colibri-imx6ull-mender-manual-U-Boot-integration.patch \
"

