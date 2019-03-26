inherit image_types

# This is a re-work of meta-otroid/classes/image_types_odroid.bbclass

# It is not possible to specific this using MENDER_IMAGE_BOOTLOADER_FILE/OFFSET,
# instead we use an append to "sdimg" to embedd the bootloader

generic_odroid_xu_wic_cmd() {
    outimgname="${IMGDEPLOYDIR}/${IMAGE_NAME}.$suffix"
    dd if=${DEPLOY_DIR_IMAGE}/bl1.bin.hardkernel of=${outimgname} conv=notrunc bs=512 seek=1
    dd if=${DEPLOY_DIR_IMAGE}/bl2.bin.hardkernel of=${outimgname} conv=notrunc bs=512 seek=31
    dd if=${DEPLOY_DIR_IMAGE}/u-boot-dtb.bin of=${outimgname} conv=notrunc bs=512 seek=63
    dd if=${DEPLOY_DIR_IMAGE}/tzsw.bin.hardkernel of=${outimgname} conv=notrunc bs=512 seek=2111
    dd if=/dev/zero of=${outimgname} conv=notrunc count=32 bs=512 seek="2625"
}

IMAGE_CMD_wic_append_odroid-xu3() {
    generic_odroid_xu_wic_cmd
}

IMAGE_CMD_wic_append_odroid-xu4() {
    generic_odroid_xu_wic_cmd
}

IMAGE_CMD_wic_append_odroid-xu3-lite() {
    generic_odroid_xu_wic_cmd
}

IMAGE_CMD_wic_append_odroid-hc1() {
    generic_odroid_xu_wic_cmd
}

IMAGE_CMD_wic_append_odroid-c1() {
    outimgname="${IMGDEPLOYDIR}/${IMAGE_NAME}.$suffix"
    dd if=${DEPLOY_DIR_IMAGE}/bl1.bin.hardkernel   of=${outimgname} conv=notrunc bs=1 count=442
    dd if=${DEPLOY_DIR_IMAGE}/bl1.bin.hardkernel   of=${outimgname} conv=notrunc bs=512 skip=1 seek=1
    dd if=${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX} of=${outimgname} conv=notrunc bs=512 seek=64
}

IMAGE_CMD_sdimg_append_odroid-c2() {
    outimgname="${IMGDEPLOYDIR}/${IMAGE_NAME}.$suffix"
    dd if=${DEPLOY_DIR_IMAGE}/bl1.bin.hardkernel   of=${outimgname} conv=notrunc bs=1 count=442
    dd if=${DEPLOY_DIR_IMAGE}/bl1.bin.hardkernel   of=${outimgname} conv=notrunc bs=512 skip=1 seek=1
    dd if=${DEPLOY_DIR_IMAGE}/u-boot-dtb.bin of=${outimgname} conv=notrunc bs=512 seek=97
}
