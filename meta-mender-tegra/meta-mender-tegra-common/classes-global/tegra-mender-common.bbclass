# The scheme-independent half of the Tegra Mender integration. Not inherited
# directly: a build inherits one of the scheme classes, tegra-mender-classic or
# tegra-mender-native, and gets this through it.
#
# Keep this inherit. meta-tegra's tegra-common.inc derives
# TEGRA_UEFI_FW_VERSION from L4T_VERSION but does not inherit l4t_version
# itself, so dropping it here leaves the UEFI capsule signing version unset.
inherit l4t_version

# Exactly one scheme layer must be in BBLAYERS, and the class inherited must be
# the one belonging to it.
#
# The two selectors are independent. Which layers are present decides which
# recipes and bbappends the build sees, while INHERIT decides which scheme's
# configuration applies, and bitbake has no way to declare that two layers
# conflict. So this is the only place the two can be checked against each other,
# and it lives in the common layer because that is the one present in every valid
# configuration.
#
# The case that earns the check is both scheme layers in BBLAYERS with one of them
# inherited. That builds cleanly, because bbappends come from BBFILES and have
# nothing to do with INHERIT, so the unselected scheme's bbappends land on top of
# the selected scheme's configuration. On this platform the result is an image
# whose slot verification is wired to the wrong scheme, which with
# RootfsRetryCountMax at 1 costs the rollback window on the first deployment.
TEGRA_MENDER_SCHEME ??= ""
TEGRA_MENDER_SCHEME_COLLECTIONS ?= "meta-mender-tegra-classic meta-mender-tegra-native"

# Checked from a ConfigParsed handler rather than anonymous python, because this
# is a configuration error and anonymous python would only reach it once recipe
# parsing had started, reporting it against whichever unrelated recipe happened to
# be parsed first.
addhandler tegra_mender_check_scheme
tegra_mender_check_scheme[eventmask] = "bb.event.ConfigParsed"
python tegra_mender_check_scheme() {
    d = e.data
    schemes = (d.getVar('TEGRA_MENDER_SCHEME_COLLECTIONS') or '').split()
    present = [c for c in (d.getVar('BBFILE_COLLECTIONS') or '').split() if c in schemes]
    scheme = d.getVar('TEGRA_MENDER_SCHEME') or ''

    if len(present) != 1:
        bb.fatal('Expected exactly one Tegra Mender scheme layer in BBLAYERS, found '
                 '%s. Add one of %s, and only one.'
                 % (', '.join(present) if present else 'none', ', '.join(schemes)))
    if not scheme:
        bb.fatal('%s is in BBLAYERS but no scheme class was inherited, so none of its '
                 'configuration applies. Add INHERIT += "tegra-mender-%s" rather than '
                 'inheriting tegra-mender-common directly.'
                 % (present[0], present[0].rsplit('-', 1)[1]))
}

# There is deliberately no third check that TEGRA_MENDER_SCHEME agrees with the
# layer that is present. It cannot be made to fail: each scheme class lives in its
# own layer and assigns the variable itself, so inheriting the other scheme's class
# means the file is not on BBPATH and the parse fails first, and a value set in
# local.conf is overwritten by the class, which is parsed after it. A check that
# cannot fire is worse than none, because it reads as coverage.

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

# Note: this isn't really a boot file, just put it here to keep the mender build from
# complaining about empty IMAGE_BOOT_FILES.  We won't use the full image anyway, just the mender file
IMAGE_BOOT_FILES = "u-boot-dtb.bin"
# Mender customizations to support jetson platforms.  This needs to
# match up with your defined flash or sdcard layout.
# You will need to update these partition values when you update the flash layout.  One way to find the correct number is to
# boot into an emergency shell and examine the /dev/mmcblk* devices,
# or use the uboot console to look at mtdparts
MENDER_DATA_PART_NUMBER_DEFAULT:tegra234 = "15"
# ...except where we substitute our own external layout, which moves the data
# image off UDA and onto permanet_user_storage so that it is the last partition
# and can be grown. Keep this in step with the PARTITION_FILE_EXTERNAL override
# in recipes-bsp/tegra-binaries/tegra-storage-layout_%.bbappend.
MENDER_DATA_PART_NUMBER_DEFAULT:p3768-0000-p3767-0000 = "17"
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
# The SD-card Orin Nano devkit keeps the mmcblk0 default: an Orin Nano module has
# no eMMC, so sdmmc1 is the only MMC controller and the card takes index 0. Naming
# it mmcblk1 fails in a way nothing at build time catches, and that is not obvious
# on the board either: the rootfs mounts, the network comes up and answers ARP, and
# then boot stalls before sshd on a /data mount that can never succeed.
# State the NVMe variant explicitly rather than leaning on TNSPEC_BOOTDEV, since it
# shares MACHINEOVERRIDES with the SD one.
MENDER_STORAGE_DEVICE_DEFAULT:jetson-orin-nano-devkit-nvme = "/dev/nvme0n1"

# A/B rootfs updates need the redundant flash layout. In practice it is already
# on, because the tegrademo distro enables it and the tegra kas configurations
# select that distro, but nothing in this layer requires tegrademo. Built
# against another distro, meta-tegra's own default of 0 applies and the machine
# gets a single-slot layout while mender still expects two, which surfaces only
# when a deployment cannot find the inactive slot. Set it here so the layer does
# not depend on the distro for something its update scheme requires.
#
# meta-tegra still forces it off where the machine has no redundant external
# layout to select, and a board can pin USE_REDUNDANT_FLASH_LAYOUT directly.
USE_REDUNDANT_FLASH_LAYOUT_DEFAULT:tegra = "1"

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
#
# mender-uboot belongs to the classic scheme by intent, since it is what pulls a
# libubootenv provider into the client's runtime dependencies. It stays here
# anyway, because the kas configurations disable it globally and a disable beats
# an enable, so moving it would change what anyone who does not disable it gets.
# Worth untangling separately, once native can simply not ask for it.
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
                 'tegra-mender-common. Set MENDER_STORAGE_TOTAL_SIZE_MB explicitly, '
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

# mender-setup-image adds kernel-image and kernel-devicetree to
# MACHINE_ESSENTIAL_EXTRA_RDEPENDS, but the kernel is carried in the boot
# partitions on these platforms, not the rootfs.
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:remove:tegra234 = "kernel-image kernel-devicetree"
MACHINE_ESSENTIAL_EXTRA_RDEPENDS:remove:tegra264 = "kernel-image kernel-devicetree"
