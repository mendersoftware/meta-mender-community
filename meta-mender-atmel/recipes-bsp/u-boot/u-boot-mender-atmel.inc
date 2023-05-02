FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:sama5d27-som1-ek-sd = "\
	file://0001-ARM-sama5d27_som1_ek-Add-support-to-mender-for-U-Boo.patch \
"

SRC_URI:append:sama5d3-xplained-sd = "\
	file://0001-Arm-Atmel-Add-mender-support-for-sama5d3-xplained.patch \
"
SRC_URI:append:sama5d3-xplained = "\
	file://0001-ARM-Add-Mender-support-for-sama5d3_xplained_nandflas.patch \
"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
BOOTENV_SIZE = "0x1000"
BOOTENV_SIZE:sama5d3-xplained = "0x20000"

MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1:sama5d3-xplained = "0x140000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2:sama5d3-xplained = "0x100000"