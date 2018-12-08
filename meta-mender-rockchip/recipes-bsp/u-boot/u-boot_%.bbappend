DEPENDS += "u-boot-mkimage-native"

UBOOT_ROCKCHIP_BINARY = "u-boot-rockchip.img"
UBOOT_IMAGE_ROCKCHIP ?= "u-boot-rockchip-${MACHINE}-${PV}-${PR}.${UBOOT_SUFFIX}"
UBOOT_SYMLINK_ROCKCHIP ?= "u-boot-rockchip-${MACHINE}.${UBOOT_SUFFIX}"

do_compile_append_rk3288() {
    mkimage -n ${SOC_FAMILY} -T rksd -d ${B}/${SPL_BINARY} ${B}/${UBOOT_ROCKCHIP_BINARY}
    cat ${B}/${UBOOT_BINARY} >>${B}/${UBOOT_ROCKCHIP_BINARY}
}

do_deploy_append_rk3288() {
    install -m 644 ${B}/${UBOOT_ROCKCHIP_BINARY} ${DEPLOYDIR}/${UBOOT_IMAGE_ROCKCHIP}

    cd ${DEPLOYDIR}
    rm -f ${UBOOT_ROCKCHIP_BINARY} ${UBOOT_SYMLINK_ROCKCHIP}
    ln -sf ${UBOOT_IMAGE_ROCKCHIP} ${UBOOT_SYMLINK_ROCKCHIP}
    ln -sf ${UBOOT_IMAGE_ROCKCHIP} ${UBOOT_ROCKCHIP_BINARY}
}
