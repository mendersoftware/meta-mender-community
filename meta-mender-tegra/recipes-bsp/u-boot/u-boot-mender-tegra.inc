FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
# On tegra devices with a real emmc, Use the mmcblk0boot1 partition for uboot environment (partition 2 in uboot)
MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART_tegra186 = "2"
# On jetson-nano without a real emmc and sd-card instead (no emmc boot partition), use the user area for uboot environment
MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART_tegra210 = "0"

# For devices with real emmc, calculate this offset by adding up the offsets of each partition preceeding the uboot_env partition in sdmmc_boot and aligning to the next
# 4096 byte boundary, then subtracting 4 MiB (4194304) since the sdmmc_boot represents the combined boot0 and boot1 partitions
# Please note the suggestions in the nvidia thread at https://devtalk.nvidia.com/default/topic/1063652/jetson-tx2/mmcblk0boot1-usage-at-address-4177408-and-u-boot-parameter-storage-space-availability/
# regarding suggestions about locating this environment area in mmcblk0boot1 at 0x3BB000 (3911680)
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_tegra186 = "3911680"

# For devices with sd-card, u-boot env is in the ENV partition (see sdcard-layout-mender.in, but keep in mind all partitions 'start block' must be a multiple of
# 2048 (one block is 512 bytes), thus the easiest way to find out the offset of the ENV partition is to use gptdisk.
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_tegra210 = "0xC00000"

# Use the sd-card (mmc device 1 from u-boot numbering scheme's point of view) to store u-boot environment
MENDER_UBOOT_STORAGE_DEVICE_tegra210 = "1"

SRC_URI += " file://0001-env-tool-add-command-line-option-to-input-lockfile-p.patch"
SRC_URI += " file://0003-tegra-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_append_mender-uboot = " file://0002-env-tool-fix-missing-equals.patch"
SRC_URI_append_mender-uboot = " file://0010-tegra-mender-auto-configured-modified.patch"
SRC_URI_append_mender-uboot = " file://0011-Jetson-TX2-mender-boot-commands.patch"
SRC_URI_append_mender-uboot = " file://0012-Update-environment-defaults-for-tegra.patch"
SRC_URI_append_mender-uboot = " file://0013-Jetson-Nano-mender-environment-in-mmc.patch"
SRC_URI_remove = " file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_remove = " file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"
