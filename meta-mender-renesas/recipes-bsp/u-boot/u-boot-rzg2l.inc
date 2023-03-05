FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

# No automatic patching
MENDER_UBOOT_AUTO_CONFIGURE = "0"

SRC_URI:append:mender-uboot = " file://smarc-rzg2l.h.mender.patch"
SRC_URI:append:mender-uboot = " file://smarc-rzg2l_defconfig.mender.patch"

BOOTENV_SIZE_smarc-rzg2l ?= "0x20000"

# U-boot Env Configuration
MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART = "2"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET = "0xFFFE0000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2 = "0xFFFC0000"

CONFIG_ENV_UBI_VOLUME = "env"
CONFIG_ENV_UBI_VOLUME_REDUND = "env_redund"