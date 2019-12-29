FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
# Use the mmcblk0boot1 partition for uboot environment (partition 2 in uboot)
MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART = "2"

# Calculate this offset by adding up the offsets of each partition preceeding the uboot_env partition in sdmmc_boot and aligning to the next
# 4096 byte boundary, then subtracting 4 MiB (4194304) since the sdmmc_boot represents the combined boot0 and boot1 partitions
# Please note the suggestions in the nvidia thread at https://devtalk.nvidia.com/default/topic/1063652/jetson-tx2/mmcblk0boot1-usage-at-address-4177408-and-u-boot-parameter-storage-space-availability/
# regarding suggestions about locating this environment area in mmcblk0boot1 at 0x3BB000 (3911680)
# We use the same offset for tegra210 eMMC. For tegra210 SPI/SD, we
# locate the environment in the padding block, before the VER partition.
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_tegra186 = "3911680"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_tegra210 = "${@'3866624' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else '3911680'}"
MENDER_UBOOT_MMC_ENV_LINUX_DEVICE_PATH_tegra210 = "${@'/dev/mtdblock0' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else mender_get_uboot_env_mmc_linux_device_path(d)}"

# Use SDcard device on Nano developer boards
MENDER_UBOOT_STORAGE_DEVICE_tegra210 = "${@'1' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else '0'}"

SRC_URI += " file://0001-env-tool-add-command-line-option-to-input-lockfile-p.patch"
SRC_URI += " file://0003-tegra-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_append_mender-uboot = " file://0010-tegra-mender-auto-configured-modified.patch"
SRC_URI_append_mender-uboot = " file://0011-Jetson-TX2-mender-boot-commands.patch"
SRC_URI_append_mender-uboot = " file://0012-Update-environment-defaults-for-tegra.patch"
SRC_URI_append_mender-uboot = " file://0013-Move-env-offset-for-tegra210-platforms.patch"
SRC_URI_remove = " file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_remove = " file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"

do_provide_mender_defines_append_tegra210() {
    if [ "${TEGRA_SPIFLASH_BOOT}" = "1" ]; then
        sed -i -e'/^CONFIG_SYS_MMC_ENV/d' ${S}/mender_Kconfig_fragment
    fi
}