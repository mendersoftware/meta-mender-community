require recipes-bsp/u-boot/u-boot-mender.inc
require u-boot-mender-nxp.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-fslc/patches:"

DEPENDS:append = " u-boot-scr"

do_deploy:append:cubox-i(){
	# Machine cubox-i requires SPL and u-boot.img to boot so
	# these two file are concatinated together into a single file
	rm -f ${D}/boot/${MENDER_IMAGE_BOOTLOADER_FILE}
	install -m 644 ${D}/boot/${SPL_BINARY} ${DEPLOYDIR}/${MENDER_IMAGE_BOOTLOADER_FILE}
	dd if=${D}/boot/${UBOOT_BINARY} of=${DEPLOYDIR}/${MENDER_IMAGE_BOOTLOADER_FILE} bs=1k seek=68
}
