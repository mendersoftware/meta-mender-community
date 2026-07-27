# Keep this inherit. meta-tegra's tegra-common.inc derives
# TEGRA_UEFI_FW_VERSION from L4T_VERSION but does not inherit l4t_version
# itself, so dropping it here leaves the UEFI capsule signing version unset.
inherit l4t_version

def tegra_mender_set_rootfs_partsize(calc_rootfs_size_kb):
    return calc_rootfs_size_kb * 1024

def tegra_mender_image_rootfs_size(d):
    rootfspart_size = d.getVar('ROOTFSPART_SIZE')
    if rootfspart_size:
        calc_rootfs_size = int(rootfspart_size) // 1024
    else:
        calc_rootfs_size = int(d.getVar('MENDER_CALC_ROOTFS_SIZE'))
    calc_rootfs_size = (calc_rootfs_size * 95) // 100
    return calc_rootfs_size - eval(d.getVar('IMAGE_ROOTFS_EXTRA_SPACE'))

# meta-tegra and tegraflash requirements
# meta-tegra renamed the flashable image type "tegraflash" -> "tegraflash-tar"
# in the JetPack 7 / wrynose era; track that rename here.
IMAGE_CLASSES += "image_types_mender_tegra"
IMAGE_FSTYPES += "tegraflash-tar"

ARTIFACTIMG_FSTYPE = "ext4"
# Generate dataimg for use with the tegraflash-tar package
IMAGE_TYPEDEP:tegraflash-tar += " dataimg"
IMAGE_FSTYPES += "dataimg"
PREFERRED_PROVIDER_u-boot-fw-utils = "u-boot-fw-utils-tegra"
PREFERRED_PROVIDER_libubootenv:tegra = "libubootenv"
PREFERRED_RPROVIDER_u-boot-fw-utils = "u-boot-fw-utils-tegra"
PREFERRED_RPROVIDER_libubootenv-bin:tegra = "libubootenv-bin"
PREFERRED_PROVIDER_libubootenv:tegra234 = "libubootenv-fake"
PREFERRED_PROVIDER_libubootenv:tegra264 = "libubootenv-fake"

# Note: this isn't really a boot file, just put it here to keep the mender build from
# complaining about empty IMAGE_BOOT_FILES.  We won't use the full image anyway, just the mender file
IMAGE_BOOT_FILES = "u-boot-dtb.bin"
# Mender customizations to support jetson platforms.  This needs to
# match up with your defined flash or sdcard layout.
# You will need to update these partition values when you update the flash layout.  One way to find the correct number is to
# boot into an emergency shell and examine the /dev/mmcblk* devices,
# or use the uboot console to look at mtdparts
MENDER_DATA_PART_NUMBER_DEFAULT:tegra234 = "15"
# t264 stock A/B NVMe layout (flash_l4t_t264_nvme_rootfs_ab.xml): APP=id1=p1,
# APP_b=id2=p2, UDA=p11 (confirmed via nvflashxmlparse).
MENDER_DATA_PART_NUMBER_DEFAULT:tegra264 = "11"
MENDER_ROOTFS_PART_A_NUMBER_DEFAULT = "1"
MENDER_ROOTFS_PART_B_NUMBER_DEFAULT:tegra234 = "2"
MENDER_ROOTFS_PART_B_NUMBER_DEFAULT:tegra264 = "2"
# mender defaults MENDER_STORAGE_DEVICE to /dev/mmcblk0. The Jetsons that boot
# from NVMe have no eMMC at all, so that names a device node which never
# appears at runtime: /data cannot mount and a rootfs deployment cannot find
# the inactive slot. TNSPEC_BOOTDEV is the BSP's own statement of where the
# rootfs lives, so take the device from it.
MENDER_STORAGE_DEVICE_DEFAULT:tegra = "${@'/dev/nvme0n1' if (d.getVar('TNSPEC_BOOTDEV') or '').startswith('nvme') else '/dev/mmcblk0'}"
# The SD-card Orin Nano devkit enumerates its card as mmcblk1.
MENDER_STORAGE_DEVICE_DEFAULT:jetson-orin-nano-devkit = "/dev/mmcblk1"
# The NVMe variant of that devkit would otherwise inherit the line above,
# because jetson-orin-nano-devkit is in its MACHINEOVERRIDES.
MENDER_STORAGE_DEVICE_DEFAULT:jetson-orin-nano-devkit-nvme = "/dev/nvme0n1"

# Use a 4096 byte alignment for support of tegraflash scheme and default partition locations
MENDER_PARTITION_ALIGNMENT = "4096"

MENDER_RESERVED_SPACE_BOOTLOADER_DATA = "0"

# See note in https://docs.mender.io/1.7/troubleshooting/running-yocto-project-image#i-moved-from-an-older-meta-mender-branch-to-the-thud-branch-and
# Prevents build failure during mkfs.ext4 step on warrior
MENDER_PARTITIONING_OVERHEAD_KB = "0"
# We don't use a boot partition in the mender image, we use tegraflash to setup our boot partition
MENDER_BOOT_PART = ""
MENDER_BOOT_PART_SIZE_MB = "0"

# Calculate the ROOTFSPART_SIZE value based on the *calculated*
# IMAGE_ROOTFS_SIZE set by mender. Do *not* use ${IMAGE_ROOTFS_SIZE}
# here; when we're called on in the context of an initramfs image
# build (for BUP payload generation), its size is set smaller than
# the actual rootfs image, so the resulting flash layout XML files
# will be different between the two contexts, leading to boot
# failures after bootloader updates.
ROOTFSPART_SIZE = "${@tegra_mender_set_rootfs_partsize(${MENDER_CALC_ROOTFS_SIZE})}"

# See https://hub.mender.io/t/yocto-thud-release-and-mender/144
# Default for thud and later is grub integration but we need to use u-boot integration already included.
# Leave out sdimg since we don't use this with tegra (instead use
# tegraflash)
MENDER_FEATURES_ENABLE:append:tegra = " mender-uboot mender-persist-systemd-machine-id"
MENDER_FEATURES_DISABLE:append:tegra = " mender-grub mender-image-uefi"

# Total size across both rootfs slots; each slot ends up at roughly half of
# MENDER_STORAGE_TOTAL_SIZE_MB, ignoring alignment.
#
# Every machine on this branch boots from external storage and takes its A/B
# slot sizes from the machine's own L4T flash layout, so the total is derived
# from that rather than from an internal-storage size.
def tegra_mender_calc_total_size(d):
    if d.getVar('EMMC_SIZE'):
        # The eMMC path was dropped along with the tegra210/186/194 machines,
        # which were the only ones that set this. Fail loudly rather than
        # silently sizing an eMMC machine off the flash layout.
        bb.fatal('EMMC_SIZE is set, but the eMMC sizing path was removed from '
                 'tegra-mender-setup. Set MENDER_STORAGE_TOTAL_SIZE_MB explicitly, '
                 'or restore the path.')
    if not d.getVar('ROOTFSPART_SIZE_DEFAULT'):
        # ROOTFSPART_SIZE_REDUNDANT is derived from it and cannot expand when
        # it is unset, so there is nothing to size the slots from.
        bb.fatal('Neither EMMC_SIZE nor ROOTFSPART_SIZE_DEFAULT is set, so the '
                 'A/B slot size cannot be determined. Set ROOTFSPART_SIZE_DEFAULT '
                 'for this machine, or pin MENDER_STORAGE_TOTAL_SIZE_MB.')
    slot_mb = int(d.getVar('ROOTFSPART_SIZE_REDUNDANT')) // (1024 * 1024)
    extra_mb = int(d.getVar('MENDER_DATA_PART_SIZE_MB') or 0) \
        + int(d.getVar('MENDER_BOOT_PART_SIZE_MB') or 0) \
        + int(d.getVar('MENDER_SWAP_PART_SIZE_MB') or 0)
    return 2 * slot_mb + extra_mb

MENDER_IMAGE_ROOTFS_SIZE_DEFAULT = "${@tegra_mender_image_rootfs_size(d)}"
MENDER_STORAGE_TOTAL_SIZE_MB_DEFAULT:tegra = "${@tegra_mender_calc_total_size(d)}"

_MENDER_IMAGE_DEPS_EXTRA = ""
_MENDER_IMAGE_DEPS_EXTRA:tegra = "tegra-state-scripts:do_deploy"
do_image_mender[depends] += "${_MENDER_IMAGE_DEPS_EXTRA}"

# mender-setup-image adds kernel-image and kernel-devicetree to
# MACHINE_ESSENTIAL_EXTRA_RDEPENDS, but the kernel is carried in the boot
# partitions on these platforms, not the rootfs.
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:remove:tegra234 = "kernel-image kernel-devicetree"
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:remove:tegra264 = "kernel-image kernel-devicetree"
