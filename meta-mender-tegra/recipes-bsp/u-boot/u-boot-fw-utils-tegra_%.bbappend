require recipes-bsp/u-boot/u-boot-fw-utils-mender.inc
require recipes-bsp/u-boot/u-boot-mender-tegra.inc

RDEPENDS_${PN} += "bash"
FILES_${PN}_append_mender-uboot = " ${base_sbindir}/fw_setenv_nounlock"
SRC_URI_append_mender-uboot = " file://0007-Support-wrapper-scripts-for-fw_setenv.patch"

def mender_get_uboot_env_mmc_linux_device(d):
    storage_device = mender_get_uboot_env_mmc_linux_device_path(d)
    return storage_device.replace("/dev/","",1)

MENDER_UBOOT_MMC_ENV_LINUX_DEVICE ?= "${@mender_get_uboot_env_mmc_linux_device(d)}"

# These hacks only apply to devices which use an eMMC boot
# partition for U-Boot environment storage.
do_install_append_mender-uboot() {
    if [ ${MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART} != 0 -a "${TEGRA_SPIFLASH_BOOT}" != "1" ]; then
        # Unlock the boot partition
        echo '#!/bin/bash' > ${WORKDIR}/fw_unlock_mmc.sh
        echo "echo 0 > /sys/block/${MENDER_UBOOT_MMC_ENV_LINUX_DEVICE}/force_ro" >> ${WORKDIR}/fw_unlock_mmc.sh
        echo 'set -e' >> ${WORKDIR}/fw_unlock_mmc.sh
        echo '/sbin/fw_setenv_nounlock "$@"' >> ${WORKDIR}/fw_unlock_mmc.sh
        echo 'set +e' >> ${WORKDIR}/fw_unlock_mmc.sh
        echo "echo 1 > /sys/block/${MENDER_UBOOT_MMC_ENV_LINUX_DEVICE}/force_ro" >> ${WORKDIR}/fw_unlock_mmc.sh
        install -m 755 ${D}${base_sbindir}/fw_setenv ${D}${base_sbindir}/fw_setenv_nounlock
        install -m 755 ${WORKDIR}/fw_unlock_mmc.sh ${D}${base_sbindir}/fw_setenv
    fi
}
