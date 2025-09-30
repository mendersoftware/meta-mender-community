
#
# Create symlink for the mender dataimg, otherwise STM32_Cube_Programmer won't be
# able to tell what kind of image this is.

IMAGE_CMD:dataimg:append() {
    ln -s ${IMAGE_NAME}.dataimg ${IMGDEPLOYDIR}/${IMAGE_NAME}.dataimg.ext4
    ln -s ${IMAGE_NAME}.ext4 ${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.ext4
    ln -s ${IMAGE_NAME}.dataimg ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.dataimg.ext4
    ln -s ${IMAGE_NAME}.ext4 ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.rootfs.ext4
}
