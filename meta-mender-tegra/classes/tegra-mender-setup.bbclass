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
# Mender customizations to support jetson platforms.  This needs to
# match up with your defined flash or sdcard layout.
# You will need to update these partition values when you update the flash layout.  One way to find the correct number is to
# boot into an emergency shell and examine the /dev/mmcblk* devices,
# or use the uboot console to look at mtdparts
MENDER_DATA_PART_NUMBER_tegra186 = "31"
MENDER_DATA_PART_NUMBER_tegra194 = "38"
MENDER_DATA_PART_NUMBER_tegra210 = "${@'15' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else '20'}"
MENDER_ROOTFS_PART_A_NUMBER = "1"
MENDER_ROOTFS_PART_B_NUMBER_tegra186 = "30"
MENDER_ROOTFS_PART_B_NUMBER_tegra194 = "37"
MENDER_ROOTFS_PART_B_NUMBER_tegra210 = "${@'14' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else '19'}"

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

# Use these variables to adjust your total rootfs size across both
# images. Rootfs size will be approximately 1/2 of
# MENDER_STORAGE_TOTAL_SIZE_MB (ignoring alignment).
# Calculate the total size based on the eMMC or SDcard size configured
# for the machine, subtracting off space for the boot-related files (by
# default, 1GiB).
def mender_tegra_calc_total_size(d):
    # For pre-production Nanos, use SDCard size, which in the machine
    # config ends with a size factor (K, M, or G). Note that the
    # factors are kilo/mega/giga, rather than kibi/mibi/gibi.
    if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1':
        sdcard_size = d.getVar('TEGRAFLASH_SDCARD_SIZE')
        fchar = sdcard_size[-1:].upper()
        sdcard_size = int(sdcard_size[:-1])
        if fchar == 'G':
            total_size_bytes = sdcard_size * 1000 * 1000 * 1000
        elif fchar == 'K':
            total_size_bytes = sdcard_size * 1000
        elif fchar == 'M':
            total_size_bytes = sdcard_size * 1000 * 1000
        else:
            bb.error('TEGRAFLASH_SDCARD_SIZE does not end with G, K, or M')
    else:
        total_size_bytes = int(d.getVar('EMMC_SIZE'))
    # Mender uses mibibytes, not megabytes
    return total_size_bytes // (1024*1024) - int(d.getVar('TEGRA_MENDER_RESERVED_SPACE_MB'))

TEGRA_MENDER_RESERVED_SPACE_MB ?= "1024"
MENDER_STORAGE_TOTAL_SIZE_MB ??= "${@mender_tegra_calc_total_size(d)}"

def mender_tegra_uboot_feature(d):
    if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot'):
        return " mender-persist-systemd-machine-id"
    return " mender-uboot mender-persist-systemd-machine-id"

_MENDER_IMAGE_DEPS_EXTRA = ""
_MENDER_IMAGE_DEPS_EXTRA_tegra = "tegra-state-scripts:do_deploy"
do_image_mender[depends] += "${_MENDER_IMAGE_DEPS_EXTRA}"
