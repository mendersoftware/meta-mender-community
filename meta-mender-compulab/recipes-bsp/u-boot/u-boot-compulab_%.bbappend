require recipes-bsp/u-boot/u-boot-mender.inc
require u-boot-mender-compulab.inc

SRC_URI_append_cl-som-imx6 += " \
    file://0002-cl-som-imx6-Enable-BOOTCOUNT_ENV-and-BOOTCOUNT_LIMIT.patch \
    file://0004-cl-som-imx6-Disable-CONFIG_ENV_OFFSET-for-Mender.patch \
    file://0005-cl-som-imx6-Add-Mender-specific-BOARD_NAME.patch \
    file://0006-cl_som_imx6-Enable-Mender-environment-and-bootcomman.patch \
"
