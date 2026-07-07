DESCRIPTION = "Uno Q A/B slot-aware initramfs: reads the active slot (qbootctl) \
and mounts system_<slot> as the real rootfs"
LICENSE = "MIT"

PACKAGE_INSTALL = " \
    initramfs-framework-base \
    initramfs-module-udev \
    initramfs-module-abslot \
    initramfs-module-rootfs \
    qbootctl \
    util-linux-blkid \
    ${VIRTUAL-RUNTIME_base-utils} \
    base-passwd \
    ${ROOTFS_BOOTSTRAP_INSTALL} \
"

# Keep the ramdisk minimal.
IMAGE_FEATURES = ""
IMAGE_LINGUAS = ""

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
IMAGE_NAME_SUFFIX ?= ""

inherit core-image

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

# No kernel in the ramdisk (it's a UKI initrd)
PACKAGE_EXCLUDE = "kernel-image-*"
