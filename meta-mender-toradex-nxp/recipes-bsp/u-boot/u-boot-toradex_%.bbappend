FILESEXTRAPATHS:prepend:mender-uboot := "${THISDIR}/files:"

include ${@mender_feature_is_enabled("mender-uboot","recipes-bsp/u-boot/u-boot-mender.inc","",d)}

MENDER_UBOOT_AUTO_CONFIGURE:mender-uboot = "0"
BOOTENV_SIZE:mender-uboot = "0x4000"
MENDER_RESERVED_SPACE_BOOTLOADER_DATA:mender-uboot:colibri-imx6ull ="0x40000"
BOOTENV_SIZE:mender-uboot:colibri-imx6ull = "0x20000"

PROVIDES += "${@mender_feature_is_enabled("mender-uboot","u-boot-default-env","",d)}"
RPROVIDES:${PN} += "${@mender_feature_is_enabled("mender-uboot","u-boot","",d)}"
PROVIDES += "${@mender_feature_is_enabled("mender-uboot","u-boot-default-env","",d)}"

# Apply custom patches for Toradex u-boot
SRC_URI:append:mender-uboot = " \
    file://0001-configs-toradex-board-specific-mender-integration.patch \
"
