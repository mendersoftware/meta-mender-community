DESCRIPTION = "Mender state-script to update firmware files on Raspberry Pi boards"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit mender-state-scripts

def rpi_firmware_required_files(d):
    kernel_image = (d.getVar('SDIMG_KERNELIMAGE') or '').strip()
    if not kernel_image:
        raise bb.parse.SkipRecipe('SDIMG_KERNELIMAGE must be set for the default firmware requirements')
    files = ['config.txt', 'cmdline.txt', kernel_image]
    if bb.utils.contains('RPI_USE_U_BOOT', '1', True, False, d):
        files.append('boot.scr')
    return ' '.join(files)

RPI_FIRMWARE_REQUIRED_FILES ?= "${@rpi_firmware_required_files(d)}"
RPI_FIRMWARE_SPACE_RESERVE_KIB ?= "1024"

RDEPENDS:${PN} += "coreutils diffutils findutils util-linux-findmnt util-linux-mount util-linux-umount"

SRC_URI = "file://ArtifactInstall_Leave_50.in"

do_deploy() {
    sed -e 's#@@MENDER_ROOTFS_PART_A@@#'"${MENDER_ROOTFS_PART_A}"'#' \
        -e 's#@@MENDER_ROOTFS_PART_B@@#'"${MENDER_ROOTFS_PART_B}"'#' \
        -e 's#@@MENDER_BOOT_PART@@#'"${MENDER_BOOT_PART}"'#' \
        -e 's#@@MENDER_BOOT_PART_MOUNT_LOCATION@@#'"${MENDER_BOOT_PART_MOUNT_LOCATION}"'#' \
        -e 's#@@RPI_FIRMWARE_REQUIRED_FILES@@#'"${RPI_FIRMWARE_REQUIRED_FILES}"'#' \
        -e 's#@@RPI_FIRMWARE_SPACE_RESERVE_KIB@@#'"${RPI_FIRMWARE_SPACE_RESERVE_KIB}"'#' \
        "${UNPACKDIR}/ArtifactInstall_Leave_50.in" > "${WORKDIR}/ArtifactInstall_Leave_50"
    cp ${WORKDIR}/ArtifactInstall_Leave_50 ${MENDER_STATE_SCRIPTS_DIR}/ArtifactInstall_Leave_50
}

ALLOW_EMPTY:${PN} = "1"
