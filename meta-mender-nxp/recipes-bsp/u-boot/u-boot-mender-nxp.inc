FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-fslc:"


SRC_URI_remove = " \
	file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
	file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
"

SRC_URI_append_imx7s-warp = " \
	file://0001-ARM-WaRP7-Add-support-to-mender.patch \
"

SRC_URI_append = " \
	file://0002-Integration-of-Mender-boot-code-into-U-Boot.patch \
"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
BOOTENV_SIZE = "0x2000"
