FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Orin NX / Orin Nano on the p3768 carrier (t234): use our own external layout
# rather than the stock one.
#
# The reason is where the data partition sits. In NVIDIA's stock layouts the
# data partition comes *before* the rootfs slots, with the free space after
# them, so it can never be expanded:
#
#   stock t234:  UDA p15 @ 1248832 ... APP p1 ... APP_b p2 ends 118393408 <- free
#   stock t264:  UDA p11 @ 4003904 ... APP p1 ... APP_b p2 ends 110366784 <- free
#
# mender-growfs-data therefore has nothing to grow into and /data stays at the
# 400 MiB the layout gives it. This layout instead appends
# permanet_user_storage as the last partition, right after APP_b, so it can be
# expanded over the rest of the device.
#
# Consequence for mender: the data image lands on permanet_user_storage (id 17),
# not on UDA, so MENDER_DATA_PART_NUMBER_DEFAULT has to say 17 for the machines
# selected here. Keep the two in step; see tegra-mender-common.bbclass.
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
#
# Note this means t264 has the growth problem described above: UDA sits ahead of
# the rootfs slots, so mender-growfs-data cannot expand /data beyond 400 MiB.
# Fixing that needs a custom t264 layout with a trailing data partition, the way
# the t234 one above does it.
PARTITION_LAYOUT_EXTERNAL:tegra264 = "flash_l4t_t264_nvme_rootfs_ab.xml"
