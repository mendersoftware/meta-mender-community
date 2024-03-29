FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-fslc:"

SRC_URI:append:imx7s-warp = " \
	file://0001-ARM-WaRP7-Add-support-to-mender.patch \
"
BOOTENV_SIZE:imx7s-warp = "0x2000"

SRC_URI:append:imx7d-pico = " \
	file://0001-ARM-Pico-Pi-i.MX7D-support-to-mender.patch \
"
BOOTENV_SIZE:imx7d-pico = "0x2000"

SRC_URI:append:imx7dsabresd = " \
	file://0001-mx7dsabresd-Add-support-to-mender.patch \
"
BOOTENV_SIZE:imx7dsabresd = "0x2000"

SRC_URI:append:cubox-i = " \
	file://0001-configs-mx6cuboxi_defconfig-Enable-Mender.patch \
"
BOOTENV_SIZE:cubox-i = "0x2000"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
