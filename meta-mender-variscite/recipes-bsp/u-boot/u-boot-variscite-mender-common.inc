FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI:append:imx8mm-var-dart = " \
    file://imx8mm_var_dart_defconfig.mender.patch \
    file://imx8mm_var_dart.h.mender.patch \
"

SRC_URI:append:imx8mp-var-dart = " \
    file://0001-imx8mp_var_dart_defconfig-conf-for-imx8mp_var_dart-b.patch \
    file://0002-imx8mp_var_dart.h-uboot-cmds-modifications-to-use-me.patch \
"

MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART:imx8mm-var-dart = "0"
BOOTENV_SIZE:imx8mm-var-dart = "0x4000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET:imx8mm-var-dart = "0x400000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2:imx8mm-var-dart = "0x440000"

MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART:imx8mp-var-dart = "0"
BOOTENV_SIZE:imx8mp-var-dart = "0x4000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET:imx8mp-var-dart = "0x400000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2:imx8mp-var-dart = "0x440000"
