FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

MENDER_UBOOT_AUTO_CONFIGURE = "0"
# Use the mmcblk0boot1 partition for uboot environment (partition 2
# in uboot) or user partition (0) on Nano with SDcard environment
MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART = "${@'0' if (d.getVar('TEGRA_MENDER_UBOOT_ENV_IN_SPIFLASH') or '') != '1' and (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else '2'}"

# Calculate this offset by adding up the offsets of each partition preceeding the uboot_env partition in sdmmc_boot and aligning to the next
# 4096 byte boundary, then subtracting 4 MiB (4194304) since the sdmmc_boot represents the combined boot0 and boot1 partitions
# Please note the suggestions in the nvidia thread at https://devtalk.nvidia.com/default/topic/1063652/jetson-tx2/mmcblk0boot1-usage-at-address-4177408-and-u-boot-parameter-storage-space-availability/
# regarding suggestions about locating this environment area in mmcblk0boot1 at 0x3BB000 (3911680)
# We use the same offset for tegra210 eMMC. For tegra210 SPI/SD, we
# locate the environment in the padding block, before the VER
# partition when using SPI flash.  Otherwise, we use the location of
# the ENV partition on the SDcard - 0xC00000 (12582912).
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_tegra186 = "3911680"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_tegra210 = "${@'3866624' if (d.getVar('TEGRA_MENDER_UBOOT_ENV_IN_SPIFLASH') or '') == '1' else '12582912' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else '3911680'}"
MENDER_UBOOT_MMC_ENV_LINUX_DEVICE_PATH_tegra210 = "${@'/dev/mtdblock0' if (d.getVar('TEGRA_MENDER_UBOOT_ENV_IN_SPIFLASH') or '') == '1' else '/dev/mmcblk0' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else mender_get_uboot_env_mmc_linux_device_path(d)}"

# Optionally use SDcard instead of SPI flash on Jetson Nano dev kits.
# Starting with meta-tegra zeus branch, Nano dev kits use the SPI flash
# for the U-Boot environment (as NVIDIA does with L4T R32.3.1 and
# later).
#
# However, for Mender it may be more convenient to use an SDcard
# partition, so the Mender environment is more self-contained.
# Just set:
#
# TEGRA_MENDER_UBOOT_ENV_IN_SPIFLASH = ""
#
# in your build configuration to do that.
TEGRA_MENDER_UBOOT_ENV_IN_SPIFLASH ?= "${TEGRA_SPIFLASH_BOOT}"
MENDER_UBOOT_STORAGE_DEVICE_tegra210 = "${@'1' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else '0'}"

SRC_URI += " file://0001-env-tool-add-command-line-option-to-input-lockfile-p.patch"
SRC_URI += " file://0003-tegra-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_append_mender-uboot = " file://0010-tegra-mender-auto-configured-modified.patch"
SRC_URI_append_mender-uboot = " file://0011-Jetson-TX2-mender-boot-commands.patch"
SRC_URI_append_mender-uboot = " file://0012-Update-environment-defaults-for-tegra.patch"
SRC_URI_append_mender-uboot = " file://0013-Move-env-offset-for-tegra210-platforms.patch"
SRC_URI_append_mender-uboot = " file://0014-Handle-pre-v2020-u-boot-env-redundancy-for-tegra-pla.patch"
SRC_URI_append_mender-uboot_tegra210 = " ${@' file://0001-Move-jetson-nano-env-to-SDcard.patch' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' and (d.getVar('TEGRA_MENDER_UBOOT_ENV_IN_SPIFLASH') or '') != '1' else ''}"
SRC_URI_remove = " file://0003-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI_remove = " file://0006-env-Kconfig-Add-descriptions-so-environment-options-.patch"

do_provide_mender_defines_append_tegra210() {
    if [ "${TEGRA_MENDER_UBOOT_ENV_IN_SPIFLASH}" = "1" ]; then
        sed -i -e'/^CONFIG_SYS_MMC_ENV/d' ${S}/mender_Kconfig_fragment
    fi
}

mender_get_clean_kernel_devicetree_tegra() {
    # Singleton device tree is not required on all platforms,
    # and the value is not used on tegra platforms, so just provide a
    # dummy value.
    echo "dummy"
}
