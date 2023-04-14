FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI:append:imx8mm-var-dart = " \
    file://imx8mm_var_dart_defconfig.mender.patch \
    file://imx8mm_var_dart.h.mender.patch \
"

MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART:imx8mm-var-dart = "0"
BOOTENV_SIZE:imx8mm-var-dart = "0x4000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET:imx8mm-var-dart = "0x400000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2:imx8mm-var-dart = "0x440000"