FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"

BOOTENV_SIZE ?= "0x20000"

SRC_URI += "\
    file://0001-configs-sunxi-add-Mender-required-options.patch \
    file://0002-env-Kconfig-remove-defaults-for-SUNXI.patch \
    file://0004-sunxi-common-Increase-SIZE_LIMIT-to-fit-with-mender-.patch \
    file://0005-sunxi-common-Use-for-arm64-same-path-as-for-arm.patch \
"
