require recipes-bsp/u-boot/u-boot-mender.inc
require u-boot-mender-compulab.inc

do_deploy_append_cl-som-imx7() {
    dd if=/dev/zero count=500 bs=1K | tr '\000' '\377' > ${DEPLOYDIR}/${MACHINE}-${PV}-${PR}-firmware
    dd if=${DEPLOYDIR}/u-boot.imx of=${DEPLOYDIR}/${MACHINE}-${PV}-${PR}-firmware bs=1K seek=1 conv=notrunc
    ln -sf ${MACHINE}-${PV}-${PR}-firmware ${DEPLOYDIR}/${MACHINE}-firmware
}
