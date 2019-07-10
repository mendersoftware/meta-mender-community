IMAGE_FSTYPES_remove = "tar.bz2 ext4 sdcard.bz2"

# dummy value as the WIC plugin requires an entry but this will not be used
# for anything beside to satisfy the build dependency
IMAGE_BOOT_FILES_append = "u-boot-${MACHINE}.bin"

MENDER_IMAGE_BOOTLOADER_FILE = "imx-boot-${MACHINE}-sd.bin"
python __anonymous () {
    # For all i.MX 8* families, set MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET
    # to 2 * IMX_BOOT_SEEK
    if 'mx8' in d.getVar('MACHINEOVERRIDES').split(':'):
        imx_boot_seek = int(d.getVar('IMX_BOOT_SEEK'))
        d.setVar('MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET', str(2 * imx_boot_seek))
}

do_image_sdimg[depends] += "imx-boot:do_deploy"

IMAGE_INSTALL_append = " kernel-image kernel-devicetree"
