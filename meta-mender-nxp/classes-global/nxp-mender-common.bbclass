# Mender configuration for NXP i.MX boards on the community meta-freescale
# layer.
#
# Keyed on the family override meta-freescale already provides, so adding
# another i.MX 9 board costs nothing here. Everything below is a weak
# assignment or a documented default; an image configuration can still
# override any of it.
#
# Only mx9 is claimed. The i.MX 8 families want the same treatment and
# nothing here is specific to 9, but none of it is verified on that
# hardware, so they are left alone rather than given defaults nobody has
# booted.
#
# Inherit this from the image configuration:
#
#   INHERIT += "nxp-mender-common"

# The i.MX 9 BootROM loads a raw boot container from the start of the boot
# medium, so these boards boot through U-Boot from an SD/eMMC image rather
# than through UEFI/GRUB.
MENDER_FEATURES_ENABLE:append:mx9-generic-bsp = " mender-uboot mender-image-sd"
MENDER_FEATURES_DISABLE:append:mx9-generic-bsp = " mender-grub mender-image-uefi"

# The container meta-freescale builds for that BootROM.
MENDER_IMAGE_BOOTLOADER_FILE:mx9-generic-bsp ?= "imx-boot"

# Where it has to sit. meta-freescale states this per SoC in KiB as
# IMX_BOOT_SEEK, Mender wants 512-byte sectors, and the value is not uniform
# across i.MX parts. Getting it wrong produces a board with no serial output
# at all, so derive it rather than restate it per board.
MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET:mx9-generic-bsp ?= "${@int(d.getVar('IMX_BOOT_SEEK')) * 2}"

# meta-mender places the U-Boot environment at the partition alignment, and
# imx-boot runs from 32 KiB to roughly 2.3 MB, so the alignment has to clear
# it. mender-part-images errors out if it does not, but defaulting to a
# value that works avoids the trip entirely.
MENDER_PARTITION_ALIGNMENT:mx9-generic-bsp ?= "8388608"

# u-boot-scr deploys boot.scr, but U-Boot's bootflow scan only finds it if it
# is on the boot partition, and meta-freescale defaults IMAGE_BOOT_FILES to
# the kernel plus device trees. Without this the BSP fallback bootcmd runs
# instead and A/B plus bootcount stay dormant while the board still appears
# to boot perfectly well.
IMAGE_BOOT_FILES:append:mx9-generic-bsp = "${@bb.utils.contains('MENDER_FEATURES', 'mender-uboot', ' boot.scr', '', d)}"

# Board specifics.

# meta-freescale lists every board variant's device tree in
# KERNEL_DEVICETREE. meta-mender wants exactly one and otherwise warns and
# picks the last entry, which here is an accessory overlay rather than the
# board's own DT. Name it explicitly.
MENDER_DTB_NAME_FORCE:imx93-11x11-lpddr4x-evk = "imx93-11x11-evk.dtb"
