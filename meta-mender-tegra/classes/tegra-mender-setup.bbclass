def tegra_mender_set_rootfs_size(image_rootfs_size_kb):
    return image_rootfs_size_kb*1024

# meta-tegra and tegraflash requirements
IMAGE_CLASSES += "image_types_mender_tegra"
IMAGE_FSTYPES += "tegraflash"

ARTIFACTIMG_FSTYPE = "ext4"
# Generate dataimg for use with tegraflash
IMAGE_TYPEDEP_tegraflash += " dataimg"
IMAGE_FSTYPES += "dataimg"
PREFERRED_PROVIDER_u-boot-fw-utils = "u-boot-fw-utils-tegra"
PREFERRED_RPROVIDER_u-boot-fw-utils = "u-boot-fw-utils-tegra"
# Note: this isn't really a boot file, just put it here to keep the mender build from
# complaining about empty IMAGE_BOOT_FILES.  We won't use the full image anyway, just the mender file
IMAGE_BOOT_FILES = "u-boot-dtb.bin"
# Mender customizations to support jetson tx2.  This needs to match up with flash_l4t_t186.custom.xml scheme
# You will need to update these partition values when you update the flash layout.  One way to find the correct number is to
# boot into an emergency shell and examine the /dev/mmcblk* devices, or use the uboot console to look at mtdparts
MENDER_DATA_PART_NUMBER = "31"
MENDER_ROOTFS_PART_A_NUMBER = "1"
MENDER_ROOTFS_PART_B_NUMBER = "30"

# Use a 4096 byte alignment for support of tegraflash scheme and default partition locations
MENDER_PARTITION_ALIGNMENT = "4096"

# Use no reserved space for bootloader data, since we will store in the partition block for the image
MENDER_RESERVED_SPACE_BOOTLOADER_DATA = "0"

# See note in https://docs.mender.io/1.7/troubleshooting/running-yocto-project-image#i-moved-from-an-older-meta-mender-branch-to-the-thud-branch-and
# Prevents build failure during mkfs.ext4 step on warrior
MENDER_PARTITIONING_OVERHEAD_KB = "0"
# We don't use a boot partition in the mender image, we use tegraflash to setup our boot partition
MENDER_BOOT_PART = ""
MENDER_BOOT_PART_SIZE_MB = "0"

# Calculate the ROOTFSPART_SIZE value based on IMAGE_ROOTFS_SIZE set by mender
ROOTFSPART_SIZE = "${@tegra_mender_set_rootfs_size(${IMAGE_ROOTFS_SIZE})}"

# See https://hub.mender.io/t/yocto-thud-release-and-mender/144
# Default for thud and later is grub integration but we need to use u-boot integration already included.
# Leave out sdimg since we don't use this with tegra (instead use
# tegraflash)
MENDER_FEATURES_ENABLE_append = "${@mender_tegra_uboot_feature(d)}"
MENDER_FEATURES_DISABLE_append = " mender-grub mender-image-uefi"

# Use this variable to adjust your total rootfs size across both images.  Rootfs size will be approximately 1/2 this value (ignoring alignment)
# The default is enough to build core-image-base
MENDER_STORAGE_TOTAL_SIZE_MB ??="6000"

def mender_tegra_uboot_feature(d):
    if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot'):
        return " mender-persist-systemd-machine-id"
    return " mender-uboot mender-persist-systemd-machine-id"
