require recipes-bsp/u-boot/u-boot-mender.inc
require u-boot-mender-imx.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://0001-Add-Mender-support.patch"
SRC_URI += "file://0002-Improve-boot-startup-time.patch"

# Set machine-specific variables per the definitions found in include/configs/MACHINE.h
# | VARIABLE                                 | DEFINITION             |
# | MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1 | CONFIG_ENV_OFFSET      |
# | BOOTENV_SIZE                             | CONFIG_ENV_SIZE        |
# | MENDER_UBOOT_STORAGE_DEVICE              | CONFIG_SYS_MMC_ENV_DEV |
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1_imx8mmevk = "0x400000"
BOOTENV_SIZE_imx8mmevk                             = "0x1000"
MENDER_UBOOT_STORAGE_DEVICE_imx8mmevk              = "0"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1_imx8mqevk = "0x400000"
BOOTENV_SIZE_imx8mqevk                             = "0x1000"
MENDER_UBOOT_STORAGE_DEVICE_imx8mqevk              = "1"
