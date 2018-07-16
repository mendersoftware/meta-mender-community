FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

BOOTENV_SIZE_tinker-rk3288 ?= "0x8000"

SRC_URI_append_tinker-rk3288 = " file://0001-configs-tinker_rk3288-integrate-mender-bootcmd.patch"

MENDER_UBOOT_AUTO_CONFIGURE_tinker-rk3288 = "0"
