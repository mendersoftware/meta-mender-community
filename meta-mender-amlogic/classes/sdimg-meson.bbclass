inherit image_types

DEPENDS:append:sdimg = " virtual/trusted-firmware-a"

SDIMG_COMMAND = "sdimg_command_meson_gx"
SDIMG_COMMAND:amlogic-s400 = "sdimg_command_s400"

sdimg_command_meson_gx () {
	outimagename="${IMGDEPLOYDIR}/${IMAGE_NAME}.$suffix"
	dd if=${DEPLOY_DIR_IMAGE}/u-boot.bin.sd.bin of=$outimagename conv=notrunc bs=1 count=440
	dd if=${DEPLOY_DIR_IMAGE}/u-boot.bin.sd.bin of=$outimagename conv=notrunc bs=512 skip=1 seek=1
}

sdimg_command_s400 () {
	outimagename="${IMGDEPLOYDIR}/${IMAGE_NAME}.$suffix"
	dd if=${DEPLOY_DIR_IMAGE}/u-boot.bin.mmc.bin of=$outimagename conv=notrunc bs=512 seek=1
}

IMAGE_CMD:sdimg:append () {
	${SDIMG_COMMAND}
}
