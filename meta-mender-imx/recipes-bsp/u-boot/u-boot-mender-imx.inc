FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-imx:"

# Currently, the U-Boot version in meta-freescale is
# more recent (2018.07) than the one on poky (sumo), which is in 2018.01.
# So, it is required to remove these patch.
SRC_URI_remove = " \
	file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
BOOTENV_SIZE = "0x2000"
