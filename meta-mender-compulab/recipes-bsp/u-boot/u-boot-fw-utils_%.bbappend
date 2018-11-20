require u-boot-mender-compulab.inc

SRC_URI_append_cl-som-imx6 += " \
    file://0001-cm-fx6-Enable-BOOTCOUNT_ENV-and-BOOTCOUNT_LIMIT-for-.patch \
    file://0002-cm_fx6-Disable-CONFIG_ENV_OFFSET-for-Mender.patch \
    file://fw_env.config.default \
"
