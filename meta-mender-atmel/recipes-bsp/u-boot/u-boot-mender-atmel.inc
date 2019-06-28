FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Currently, the U-Boot version in meta-atmel is
# more recent (2019.04) than the one on poky (thud), which is in 2019.01.
# So, it is required to remove these patch.

SRC_URI_remove = " \
	file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
	file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
"

SRC_URI_remove = "\
	${@bb.utils.contains('PREFERRED_VERSION_u-boot-at91', \
	'v2018.07%', \
	'', \
	'file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch', \
	d)}"

# It is also required to re-implement the patch
# "0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
# to match with mender integration.

SRC_URI_append = " \
	file://0002-Integration-of-Mender-boot-code-into-U-Boot.patch \
"

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
