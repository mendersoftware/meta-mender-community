FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-fslc:"

# Currently, the U-Boot version in meta-freescale is
# more recent (2018.11) than the one on poky (thud), which is in 2018.07.
# So, it is required to remove these patch.

SRC_URI_remove = " \
	file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
	file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch \
"

SRC_URI_append_imx7s-warp = " \
	file://0001-ARM-WaRP7-Add-support-to-mender.patch \
"
BOOTENV_SIZE_imx7s-warp = "0x2000"

SRC_URI_append_imx7d-pico = " \
	file://0001-ARM-Pico-Pi-i.MX7D-support-to-mender.patch \
"
BOOTENV_SIZE_imx7d-pico = "0x4000"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
