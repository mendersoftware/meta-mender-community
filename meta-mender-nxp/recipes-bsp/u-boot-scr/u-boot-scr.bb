SUMMARY = "U-Boot boot script for the Mender A/B integration"
DESCRIPTION = "Compiles boot.cmd into the boot.scr that U-Boot's bootflow scan \
picks up, calling mender_setup and booting the rootfs Mender selected."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "u-boot-mkimage-native"

# files/boot.cmd is board-independent: every variable it uses (console,
# image, fdtfile, loadaddr, fdt_addr_r) comes from the NXP U-Boot
# environment, and the rest is Mender's own. A board that genuinely needs
# something else can drop a boot.cmd in a machine-named subdirectory of
# files/ and it will take precedence.
SRC_URI = "file://boot.cmd"

# Nothing is unpacked into a source tree; point S at the unpack dir so
# bitbake does not warn about a missing ${UNPACKDIR}/${BP}.
S = "${UNPACKDIR}"

do_compile() {
	mkimage -C none -A arm -T script -d "${UNPACKDIR}/boot.cmd" boot.scr
}

inherit deploy

do_deploy() {
	install -d ${DEPLOYDIR}
	install -m 0644 boot.scr ${DEPLOYDIR}
}

addtask do_deploy after do_compile before do_build

# The script is board data, so architecture independent, but allarch and
# COMPATIBLE_MACHINE do not mix. Machine-specific packages it is.
PACKAGE_ARCH = "${MACHINE_ARCH}"
# Keyed on the SoC family rather than a list of machines, so another i.MX 9
# board needs no edit here. Must stay in step with the DEPENDS in
# u-boot-imx_%.bbappend: the two disagreeing is what makes u-boot-imx
# unbuildable with "Nothing PROVIDES 'u-boot-scr'".
COMPATIBLE_MACHINE = "(mx9-generic-bsp)"
