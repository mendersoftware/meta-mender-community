require recipes-bsp/u-boot/u-boot-mender.inc
require u-boot-mender-imx.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://0001-Add-Mender-support.patch"
SRC_URI += "file://0002-Improve-boot-startup-time.patch"

BOOTENV_SIZE_imx8mqevk                             = "0x1000"
MENDER_UBOOT_STORAGE_DEVICE_imx8mqevk              = "1"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1_imx8mqevk = "0x400000"
