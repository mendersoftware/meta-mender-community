FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI:append:imx93-var-som = " \
    file://0001-u-boot-variscite-configuration-adjustments-for-Mende.patch \
    file://0002-u-boot-variscite-Mender-integration-to-bootcmd.patch \
"

MENDER_UBOOT_STORAGE_DEVICE:imx93-var-som = "1"
MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART:imx93-var-som = "0"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET:imx93-var-som = "0x700000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2:imx93-var-som = "0x740000"