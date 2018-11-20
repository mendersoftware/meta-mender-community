FILESEXTRAPATHS_prepend_cl-som-imx6 := "${THISDIR}/patches:${THISDIR}/files:"

# Compulab board is using 2015.07 u-boot, need to apply a patch that matches our version
SRC_URI_remove_cl-som-imx6 += " file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_append_cl-som-imx6 += " file://0003-U-Boot-pre-2017.03-integration-of-Mender-boot-code-i.patch"

SRC_URI_append_cl-som-imx6 += " \
    file://0001-cm_fx6-Enabled-redundant-environment.patch \
    file://0003-mender-Support-CONFIG_ENV_IS_IN_SPI_FLASH.patch \
"

# UBoot environment on Compulab boards is 8kB
# Stored in SPI Flash at offset 768KB
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_1_cl-som-imx6 = "0xC0000"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_2_cl-som-imx6 = "0xC2000"
BOOTENV_SIZE_cl-som-imx6 = "0x2000"

KERNEL_DEVICETREE = "imx6q-sbc-imx6-hdmi.dtb"
