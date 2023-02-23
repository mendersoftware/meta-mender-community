
#
# Create symlink for the mender dataimg, otherwise STM32_Cube_Programmer won't be
# able to tell what kind of image this is.

IMAGE_CMD:dataimg:append:osd32mp1-emmc-mender() {
    ln -s ${IMAGE_NAME}.dataimg ${IMGDEPLOYDIR}/${IMAGE_NAME}.dataimg.ext4
}