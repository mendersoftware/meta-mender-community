FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

SRC_URI_append_imx6ul-var-dart = " \
    file://0001-mx6ul_var_dart-Remove-unneeded-boot-settings.patch \
    file://0001-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0001-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch \
    file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
"
SRC_URI_remove_imx6ul-var-dart = " \
    file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch \
    file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0004-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch \
"
SRC_URI_append_var-som-mx6 = " \
    file://0001-mx6var_som-Remove-unneeded-boot-settings.patch \
    file://0001-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0001-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch \
    file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
"
SRC_URI_remove_var-som-mx6 = " \
    file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch \
    file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0004-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch \
"

MENDER_VARISCITE_UBOOT_PRE_SETUP_COMMANDS = " \
    setenv bootargs console=\${console},\${baudrate}; \
    run videoargs; \
    run findfdt; \
    setenv mender_dtb_name \${fdt_file}; \
    setenv kernel_addr_r \${loadaddr}; \
"

MENDER_UBOOT_PRE_SETUP_COMMANDS_var-som-mx6 = "${MENDER_VARISCITE_UBOOT_PRE_SETUP_COMMANDS}"
MENDER_UBOOT_PRE_SETUP_COMMANDS_imx6ul-var-dart = "${MENDER_VARISCITE_UBOOT_PRE_SETUP_COMMANDS}"
