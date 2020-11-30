FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

include ${@mender_feature_is_enabled("mender-uboot","recipes-bsp/u-boot/u-boot-mender.inc","",d)}

SRC_URI_append_imx6ul-var-dart_mender-grub = " file://0001-Switch-to-CONFIG_DISTRO_DEFAULTS-for-bootcmd.patch "
SRC_URI_append_imx8mm-var-dart_mender-grub = " file://0001-Switch-to-CONFIG_DISTRO_DEFAULTS-for-bootcmd.patch "
SRC_URI_append_imx8mm-var-dart_mender-grub = " ${@'file://0002-Store-Env-in-eMMC.patch' if d.getVar('VARISCITE_UBOOT_ENV_IN_EMMC', True) == '1' else ''}"
SRC_URI_append_imx8mn-var-som_mender-grub = " file://0001-Switch-to-CONFIG_DISTRO_DEFAULTS-for-bootcmd.patch "
SRC_URI_append_imx8mn-var-som_mender-grub = " ${@'file://0002-Store-Env-in-eMMC.patch' if d.getVar('VARISCITE_UBOOT_ENV_IN_EMMC', True) == '1' else ''}"

PROVIDES += "u-boot"
RPROVIDES_${PN} += "u-boot"

make_u_boot_spl_image() {
    install -m 644 ${B}/${config}/${SPL_BINARY} ${DEPLOYDIR}/u-boot-spl-${PV}-${PR}.img
    rm -f ${DEPLOYDIR}/u-boot-spl.img
    ln -sf u-boot-spl-${PV}-${PR}.img ${DEPLOYDIR}/u-boot-spl.img
    dd if=${DEPLOYDIR}/u-boot.img of=${DEPLOYDIR}/u-boot-spl-${PV}-${PR}.img bs=1K seek=68 conv=notrunc
}

do_deploy_append_imx6ul-var-dart() {
    make_u_boot_spl_image
}

MENDER_UBOOT_AUTO_CONFIGURE_mender-uboot = "1"
MENDER_UBOOT_PRE_SETUP_COMMANDS_mender-uboot = " \
    if test \\\"\${ramsize_check}\\\" != \\\"\\\"; then run ramsize_check; fi; \
    if test \\\"\${mmcargs}\\\" != \\\"\\\"; then run mmcargs; fi; \
    if test \\\"\${videoargs}\\\" != \\\"\\\"; then run videoargs; fi; \
    if test \\\"\${optargs}\\\" != \\\"\\\"; then run optargs; fi; \
    run findfdt; \
    setenv mender_dtb_name \${fdt_file}; \
    setenv kernel_addr_r \${loadaddr}; \
"
