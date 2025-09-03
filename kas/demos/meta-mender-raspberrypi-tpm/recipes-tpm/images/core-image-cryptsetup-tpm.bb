include recipes-core/images/core-image-base.bb

LICENSE = "MIT"
DESCRIPTION = "A Core image based on core-image-base for rpi"

# add device tree overlay for the LetsTrust TPM
KERNEL_DEVICETREE:append = " overlays/letstrust-tpm.dtbo"

IMAGE_INSTALL:append = " \
    firstboot-init \
    cryptsetup \
    systemd-crypt \
    util-linux-lsblk \
"
