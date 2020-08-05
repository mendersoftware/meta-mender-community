FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"

BOOTENV_SIZE ?= "0x20000"

SRC_URI += "\
    file://0001-configs-sunxi-add-Mender-required-options.patch \
    file://0002-env-Kconfig-remove-defaults-for-SUNXI.patch \
"

# cannot be applied on thud (just drop it)
SRC_URI_remove_mender-uboot = " file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"
