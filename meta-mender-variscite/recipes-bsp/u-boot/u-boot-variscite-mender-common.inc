FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI:append_imx6ul-var-dart = " \
    file://0001-mx6ul_var_dart-Remove-unneeded-boot-settings.patch \
    file://0001-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0001-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch \
    file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
    file://0001-Add-Mender-MTD-variables-to-config-whitelist.patch \
    file://0001-imx6ul-var-dart-Find-splash-screen-on-active-rootfs-.patch \
"
SRC_URI:remove_imx6ul-var-dart = " \
    file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch \
    file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0004-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch \
"
SRC_URI:append_var-som-mx6 = " \
    file://0001-mx6var_som-Remove-unneeded-boot-settings.patch \
    file://0001-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0001-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch \
    file://0005-fw_env_main.c-Fix-incorrect-size-for-malloc-ed-strin.patch \
    file://0001-Add-Mender-MTD-variables-to-config-whitelist.patch \
    file://0001-mx6var_som-Remove-MMC_BOOTCMD-for-Mender.patch \
    file://0002-mx6var_som-Remove-bootenv-and-MMC-boot-processing.patch \
    file://0003-mx6var_som-Remove-parts-of-NAND_BOOT_ENV_SETTINGS.patch \
    file://0004-mx6var_som-Clear-MMC_BOOT_ENV_SETTINGS-when-configur.patch \
    file://0001-mx6var_som-Find-splash-screen-on-active-rootfs-with-.patch \
"
SRC_URI:remove_var-som-mx6 = " \
    file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch \
    file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch \
    file://0004-Disable-CONFIG_BOOTCOMMAND-and-enable-CONFIG_MENDER_.patch \
"

# Still need to handle loadbootenv and importbootenv
MENDER_VARISCITE_UBOOT_PRE_SETUP_COMMANDS = " \
    setenv bootargs console=\${console},\${baudrate}; \
    if test \\\"\${mmcargs}\\\" != \\\"\\\"; then run mmcargs; fi; \
    if test \\\"\${videoargs}\\\" != \\\"\\\"; then run videoargs; fi; \
    if test \\\"\${optargs}\\\" != \\\"\\\"; then run optargs; fi; \
    if test \\\"\${ramsize_check}\\\" != \\\"\\\"; then run ramsize_check; fi; \
    run findfdt; \
    setenv mender_dtb_name \${fdt_file}; \
    setenv kernel_addr_r \${loadaddr}; \
"

MENDER_UBOOT_PRE_SETUP_COMMANDS_var-som-mx6 = "${MENDER_VARISCITE_UBOOT_PRE_SETUP_COMMANDS}"
MENDER_UBOOT_PRE_SETUP_COMMANDS_imx6ul-var-dart = "${MENDER_VARISCITE_UBOOT_PRE_SETUP_COMMANDS}"
