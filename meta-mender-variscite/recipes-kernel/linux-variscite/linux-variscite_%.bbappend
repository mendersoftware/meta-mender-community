do_copy_defconfig_append_imx6ul-var-dart() {
    echo "CONFIG_EFI=y" >> ${WORKDIR}/defconfig
}

do_copy_defconfig_append_imx8mm-var-dart() {
    echo "CONFIG_EFI=y" >> ${WORKDIR}/defconfig
}

do_copy_defconfig_append_imx8mn-var-som() {
    echo "CONFIG_EFI=y" >> ${WORKDIR}/defconfig
}
