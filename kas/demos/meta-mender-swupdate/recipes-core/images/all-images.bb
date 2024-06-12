DESCRIPTION = "Main image as standalone and wrapped in SWU"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit image

# Disable most of the image build process
do_rootfs[noexec] = "1"
do_rootfs_wicenv[noexec] = "1"
do_image[noexec] = "1"
do_image_wic[noexec] = "1"
do_image_ext3[noexec] = "1"
do_image_ext4[noexec] = "1"
do_image_tar[noexec] = "1"
do_image_complete[noexec] = "1"
do_image_complete_setscene[noexec] = "1"
do_image_qa[noexec] = "1"
do_image_qa_setscene[noexec] = "1"
do_build[noexec] = "1"

do_image[depends] += "swu-image:do_swuimage main-image:do_image_complete"
