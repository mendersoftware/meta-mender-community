FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Orin Nano devkit (t234, JetPack 5/6)
SRC_URI:append:p3768-0000-p3767-0000 = " \
    file://flash_l4t_t234_nvme_rootfs_ab.xml \
"

PARTITION_FILE_EXTERNAL:p3768-0000-p3767-0000 = "${UNPACKDIR}/flash_l4t_t234_nvme_rootfs_ab.xml"

# AGX Thor / t264 (JetPack 7): select NVIDIA's stock redundant (A/B) external
# NVMe layout instead of the single-rootfs default (flash_l4t_t264_nvme.xml).
# The file ships in the L4T BSP (Linux_for_Tegra/tools/kernel_flash/), so
# tegra-storage-layout-base stages it via the default PARTITION_FILE_EXTERNAL
# -- no custom XML required. The mender tegra-storage-layout-base bbappend then
# rewrites the UDA partition's <filename> to DATAFILE so the mender data image
# is flashed into it. Layout (confirmed via nvflashxmlparse): APP=p1 (rootfs A),
# APP_b=p2 (rootfs B), UDA=p11 (data); all fixed-size with free space after the
# rootfs partitions.
PARTITION_LAYOUT_EXTERNAL:tegra264 = "flash_l4t_t264_nvme_rootfs_ab.xml"
