FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-fslc:"

# Currently, the U-Boot version in meta-freescale is
# more recent (2018.07) than the one on poky (sumo), which is in 2018.01.
# So, it is required to remove these patch.

SRC_URI_remove = " \
	file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
	file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
"

SRC_URI_append_imx7s-warp = " \
	file://0001-ARM-WaRP7-Add-support-to-mender.patch \
"

SRC_URI_append_imx7d-pico = " \
	file://0001-Add-NXP-Pico-Pi-imx7d-board.patch \
"

# It is also required to re-implement the patch
# "0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
# to match with mender integration.

SRC_URI_append = " \
	file://0002-Integration-of-Mender-boot-code-into-U-Boot.patch \
"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
BOOTENV_SIZE = "0x2000"
