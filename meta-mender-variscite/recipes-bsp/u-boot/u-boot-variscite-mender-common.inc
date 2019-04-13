FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

SRC_URI_append_imx6ul-var-dart = " file://0001-mx6ul_var_dart-Remove-unneeded-boot-settings.patch "
SRC_URI_remove_imx6ul-var-dart = " file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"
SRC_URI_append_var-som-mx6 = " file://0001-mx6var_som-Remove-unneeded-boot-settings.patch "
SRC_URI_remove_var-som-mx6 = " file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"

MENDER_VARISCITE_UBOOT_PRE_SETUP_COMMANDS = " \
    setenv bootargs console=\${console},\${baudrate}; \
    run videoargs; \
    run findfdt; \
    setenv mender_dtb_name \${fdt_file}; \
    setenv kernel_addr_r \${loadaddr}; \
"

MENDER_UBOOT_PRE_SETUP_COMMANDS_var-som-mx6 = "${MENDER_VARISCITE_UBOOT_PRE_SETUP_COMMANDS}"
MENDER_UBOOT_PRE_SETUP_COMMANDS_imx6ul-var-dart = "${MENDER_VARISCITE_UBOOT_PRE_SETUP_COMMANDS}"
