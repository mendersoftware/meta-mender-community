MENDER_UBOOT_AUTO_CONFIGURE = "0"
MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART = "2"

TEGRA_MENDER_BOOTENV_SIZE_DEFAULT = "0x20000"
TEGRA_MENDER_BOOTENV_SIZE_DEFAULT_tegra210 = "${@'0x10000' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else '0x20000'}"
BOOTENV_SIZE ?= "${TEGRA_MENDER_BOOTENV_SIZE_DEFAULT}"

# Calculate this offset by adding up the offsets of each partition preceeding the uboot_env partition in sdmmc_boot and aligning to the next
# 4096 byte boundary, then subtracting 4 MiB (4194304) since the sdmmc_boot represents the combined boot0 and boot1 partitions
# Please note the suggestions in the nvidia thread at https://devtalk.nvidia.com/default/topic/1063652/jetson-tx2/mmcblk0boot1-usage-at-address-4177408-and-u-boot-parameter-storage-space-availability/
# regarding suggestions about locating this environment area in mmcblk0boot1 at 0x3BB000 (3911680)
# We use the same offset for tegra210 eMMC. For tegra210 SPI/SD, we
# locate the environment in the padding block, before the VER
# partition when using SPI flash.  Otherwise, we use the location of
# the ENV partition on the SDcard - 0xC00000 (12582912).
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_tegra186 = "3911680"
# Env offset changed on t210 eMMC platforms in L4T R32.5.x and later
TEGRA_210_EMMC_UBOOT_ENV_OFFSET_l4t-mender-32-4-3 = "3911680"
TEGRA_210_EMMC_UBOOT_ENV_OFFSET = "3801088"
MENDER_UBOOT_ENV_STORAGE_DEVICE_OFFSET_tegra210 = "${@'3866624' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else '${TEGRA_210_EMMC_UBOOT_ENV_OFFSET}'}"
MENDER_UBOOT_MMC_ENV_LINUX_DEVICE_PATH_tegra210 = "${@'/dev/mtd0' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else mender_get_uboot_env_mmc_linux_device_path(d)}"

# Optionally use SDcard instead of SPI flash on Jetson Nano dev kits.
# Starting with meta-tegra zeus branch, Nano dev kits use the SPI flash
# for the U-Boot environment (as NVIDIA does with L4T R32.3.1 and
# later). Note that the u-boot environment will still live on SPI flash
# and relocating the environment also to SD may be possible but is not
# supported.
MENDER_UBOOT_STORAGE_DEVICE_tegra210 = "${@'1' if (d.getVar('TEGRA_SPIFLASH_BOOT') or '') == '1' else '0'}"
