require recipes-bsp/u-boot/u-boot-mender.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-imx:"

# Scoped exactly like u-boot-scr's COMPATIBLE_MACHINE. Depending on it from
# a machine it does not claim makes u-boot-imx unbuildable with
# "Nothing PROVIDES 'u-boot-scr'", so the two must not drift apart.
DEPENDS:append:mx9-generic-bsp = " u-boot-scr"

# The defconfig changes are carried explicitly rather than generated, so
# that what ends up in U-Boot is reviewable.
#
# Set the environment offsets globally, not here: libubootenv needs them too.
#
# Only for boards whose defconfig patch is carried here. A board without one
# should get meta-mender's generated configuration rather than silently
# getting neither.
MENDER_UBOOT_AUTO_CONFIGURE:imx93-11x11-lpddr4x-evk = "0"

# meta-mender's 0002 patch does not apply to NXP's downstream tree: its
# include/env_default.h still uses CONFIG_USE_DEFAULT_ENV_FILE, which
# mainline U-Boot renamed to CONFIG_ENV_USE_DEFAULT_ENV_TEXT_FILE, so
# hunk 2 is rejected. Substitute a context-refreshed copy. Everything
# else about the patch is unchanged.
SRC_URI:remove:mender-uboot = " file://0002-Integration-of-Mender-boot-code-into-U-Boot.patch"
SRC_URI:append:mender-uboot = " file://0002-Integration-of-Mender-boot-code-into-U-Boot-nxp.patch"

# Same story, other direction: meta-mender's config_mender.h requires
# CONFIG_ENV_REDUNDANT, the name upstream U-Boot adopted after v2025.04
# and the one oe-core's u-boot 2026.01 uses. NXP's lf_v2025.04 still
# calls it SYS_REDUNDAND_ENVIRONMENT. Add an alias symbol.
SRC_URI:append:mender-uboot = " file://0003-env-Provide-ENV_REDUNDANT-alias-for-SYS_REDUNDAND_EN.patch"

SRC_URI:append:imx93-11x11-lpddr4x-evk = " \
	file://0001-imx93_11x11_evk-Enable-Mender-configuration.patch \
"

# NXP's imx93 defconfigs set CONFIG_EFI_CAPSULE_AUTHENTICATE, which makes
# the DTB build run cert-to-efi-sig-list (scripts/Makefile.lib). That
# binary ships in efitools-native, which exists only in meta-imx-sdk, so
# an imx93 build on community meta-freescale alone fails to compile
# U-Boot. Mender does the updating here, EFI capsules are not used, so
# turn the feature off rather than drag in the whole NXP SDK layer.
#
# This is a meta-freescale gap rather than a Mender concern; it lives
# here only because this layer is the one every Mender build of the board
# already pulls in. The proper fix is an efitools recipe in
# meta-freescale, after which this can go.
SRC_URI:append:mx93-generic-bsp = " file://no-efi-capsule-auth.cfg"
