FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"

BOOTENV_SIZE ?= "0x20000"

SRC_URI += "\
    file://0001-env-Kconfig-remove-defaults-for-SUNXI.patch \
    file://0002-configs-sunxi-add-Mender-required-options.patch \
"
