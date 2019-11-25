FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-fslc:"

SRC_URI_append_imx7s-warp = " \
	file://0001-ARM-WaRP7-Add-support-to-mender.patch \
"
BOOTENV_SIZE_imx7s-warp = "0x2000"

SRC_URI_append_imx7d-pico = " \
	file://0001-ARM-Pico-Pi-i.MX7D-support-to-mender.patch \
"
BOOTENV_SIZE_imx7d-pico = "0x4000"

SRC_URI_append_imx7dsabresd = " \
	file://0001-mx7dsabresd-Add-support-to-mender.patch \
"
BOOTENV_SIZE_imx7dsabresd = "0x2000"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
