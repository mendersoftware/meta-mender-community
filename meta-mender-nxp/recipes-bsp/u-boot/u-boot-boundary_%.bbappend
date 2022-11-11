FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

require recipes-bsp/u-boot/u-boot-mender.inc

DEPENDS += "u-boot-script-boundary"

SRC_URI:remove = "file://fw_env.config"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
BOOTENV_SIZE = "0x2000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1 = "0x3fe000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2 = "0x3fc000"
MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART = "1"

SRC_URI += "\
    file://0001-nitrogen8mp-add-Mender-support.patch \
    file://0002-nitrogen8mm-add-Mender-support.patch \
    file://0003-nitrogen8m-add-Mender-support.patch \
    file://0004-nitrogen8mn-add-Mender-support.patch \
"
