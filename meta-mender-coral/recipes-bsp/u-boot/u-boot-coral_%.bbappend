require recipes-bsp/u-boot/u-boot-mender.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

SRC_URI_remove = "file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"

SRC_URI_append = " \
    file://0001-imx8mq_phanbell-add-Mender-requirements.patch \
    file://0002-U-Boot-pre-2017.03-integration-of-Mender-boot-code-i.patch \
    file://0003-default-gcc.patch \
"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
BOOTENV_SIZE = "0x1000"
