include recipes-core/images/core-image-minimal.bb

LICENSE = "MIT"
DESCRIPTION = "A Core image with encryption support for Rockchip RK3568"

# Use a unique image name to avoid conflicts with core-image-minimal
IMAGE_NAME = "${IMAGE_BASENAME}-enc"

IMAGE_INSTALL:append = " \
    firstboot-init \
    cryptsetup \
    util-linux-lsblk \
    optee-ftpm  \
    kernel-module-tpm-ftpm-tee \
    tpm2-tools \
    tpm2-tss \
    tpm2-abrmd \
    systemd-crypt \
    parted \
"
