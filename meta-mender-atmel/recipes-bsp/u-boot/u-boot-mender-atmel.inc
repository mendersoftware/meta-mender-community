FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Currently, the U-Boot version in meta-atmel is
# more recent (2018.07) than the one on poky (sumo), which is in 2018.01.
# So, it is required to remove these patch.

SRC_URI_remove = " \
	file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
	file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
"

# It is also required to re-implement the patch
# "0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
# to match with mender integration.

SRC_URI_append = " \
	file://0001-ARM-sama5d27_som1_ek-Add-support-to-mender.patch \
	file://0002-Integration-of-Mender-boot-code-into-U-Boot.patch \
"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
BOOTENV_SIZE = "0x1000"
