SUMMARY = "U-Boot boot script generator"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

DEPENDS = "u-boot-mkimage-native"

SRC_URI = "file://boot.cmd"

do_compile() {
	mkimage -C none -A arm -T script -d "${WORKDIR}/boot.cmd" boot.scr
}

do_compile:cubox-i() {
	sed -e 's/@@KERNEL_IMAGETYPE@@/${KERNEL_IMAGETYPE}/' \
	    -e 's/@@KERNEL_DEVICETREE@@/${KERNEL_DEVICETREE}/' \
	    "${WORKDIR}/boot.cmd" > "${WORKDIR}/boot.cmd.out"
	mkimage -C none -A arm -T script -d "${WORKDIR}/boot.cmd.out" boot.scr
}

inherit deploy

do_deploy() {
	install -d ${DEPLOYDIR}
	install -m 0644 boot.scr ${DEPLOYDIR}
}

addtask do_deploy after do_compile before do_build

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "(imx7s-warp|imx7d-pico|imx7dsabresd|cubox-i)"
