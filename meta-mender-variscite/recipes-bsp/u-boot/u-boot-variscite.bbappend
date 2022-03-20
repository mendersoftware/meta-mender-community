require recipes-bsp/u-boot/u-boot-variscite-mender-common.inc
require recipes-bsp/u-boot/u-boot-mender.inc

DEPENDS:append = " bc-native "

make_u_boot_spl_image() {
    install -m 644 ${B}/${config}/${SPL_BINARY} ${DEPLOYDIR}/u-boot-spl-${PV}-${PR}.img
    rm -f ${DEPLOYDIR}/u-boot-spl.img
    ln -sf u-boot-spl-${PV}-${PR}.img ${DEPLOYDIR}/u-boot-spl.img
    dd if=${DEPLOYDIR}/u-boot.img of=${DEPLOYDIR}/u-boot-spl-${PV}-${PR}.img bs=1K seek=68 conv=notrunc
}

do_deploy:append_var-som-mx6() {
    make_u_boot_spl_image
}

do_deploy:append_imx6ul-var-dart() {
    make_u_boot_spl_image
}
