FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# If you want to use the U-Boot's legacy version in thud,
# please set PREFERRED_VERSION_u-boot-at91 = "v2018.07%".

SRC_URI_append_sama5d27-som1-ek-sd += "\
	${@bb.utils.contains('PREFERRED_VERSION_u-boot-at91', \
	'v2018.07%', \
	'file://0001-ARM-sama5d27_som1_ek-Add-support-to-mender.patch', \
	'file://0001-ARM-sama5d27_som1_ek-Add-support-to-mender-for-U-Boo.patch', \
	d)}"

SRC_URI_append_sama5d3-xplained-sd += "\
	file://0001-Arm-Atmel-Add-mender-support-for-sama5d3-xplained.patch \
"
MENDER_UBOOT_AUTO_CONFIGURE = "0"
BOOTENV_SIZE = "0x1000"
