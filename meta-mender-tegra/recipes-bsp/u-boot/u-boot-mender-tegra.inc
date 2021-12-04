FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"

SRC_URI_append_mender-uboot = " file://0010-tegra-mender-auto-configured-modified.patch"
SRC_URI_append_mender-uboot = " file://0011-Jetson-TX2-mender-boot-commands.patch"
SRC_URI_append_mender-uboot = " file://0013-Reduce-env-size-on-p3450-0000-to-64KiB.patch"
SRC_URI_append_mender-uboot_l4t-mender-32-5-2 = " \
    file://0012-p3541-0000_defconfig-Mender-patch.patch \
    file://0015-Update-TX1-nano-emmc-defconfigs-for-new-UBENV-locati.patch \
    file://0017-Jetson-Xavier-NX-TX2-NX-mender.patch \
"

do_provide_mender_defines_append_tegra210() {
    if [ "${TEGRA_SPIFLASH_BOOT}" = "1" ]; then
        sed -i -e'/^CONFIG_SYS_MMC_ENV/d' ${S}/mender_Kconfig_fragment
    fi
}

mender_get_clean_kernel_devicetree_tegra() {
    # Singleton device tree is not required on all platforms,
    # and the value is not used on tegra platforms, so just provide a
    # dummy value.
    echo "dummy"
}

# Work around Mender's installation of this file (symlink)
# in its libubootenv bbappend
do_install_append_mender-uboot() {
    rm -f ${D}${sysconfdir}/fw_env.config
}
