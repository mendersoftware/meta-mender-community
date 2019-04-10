FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

BOOTENV_SIZE_imx6ul-var-dart = "0x00002000"

SRC_URI_append_imx6ul-var-dart = " file://0001-CONFIGS-mx6_ul_var_dart-add-Mender-support.patch"

SRC_URI_append_imx6ul-var-dart = " file://0001-mx6ul_var_dart-Remove-unneeded-boot-settings.patch "
SRC_URI_append_var-som-mx6 = " file://0001-mx6var_som-Remove-unneeded-boot-settings.patch "
SRC_URI_remove_var-som-mx6 = " file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"

MENDER_UBOOT_PRE_SETUP_COMMANDS_var-som-mx6 = " \
    setenv bootargs console=\${console},\${baudrate}; \
    run videoargs; \
    run findfdt; \
    setenv mender_dtb_name \${fdt_file}; \
    setenv kernel_addr_r \${loadaddr}; \
"
