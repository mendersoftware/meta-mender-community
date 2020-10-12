python __anonymous () {
    # For all i.MX 8* families, set MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET
    # to 2 * IMX_BOOT_SEEK
    if 'mx8' in d.getVar('MACHINEOVERRIDES').split(':'):
        imx_boot_seek = int(d.getVar('IMX_BOOT_SEEK'))
        d.setVar('MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET', str(2 * imx_boot_seek))
}

do_image_sdimg[depends] += "imx-boot:do_deploy"

IMAGE_INSTALL_append = " kernel-image kernel-devicetree"

IMAGE_FSTYPES_remove = "tar.bz2 ext4 sdcard.bz2 wic.bmap wic.bz2 uefiimg.bz2"
IMAGE_BOOT_FILES_remove_imx8mnevk = " ${KERNEL_IMAGETYPE} ${@make_dtb_boot_files(d)} "
MENDER_IMAGE_BOOTLOADER_FILE_imx8mnevk = "imx-boot"
