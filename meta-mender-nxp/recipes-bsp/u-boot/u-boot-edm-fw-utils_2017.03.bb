SUMMARY = "U-boot bootloader fw_printenv/setenv utils"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=a2c678cfd4a4d97135585cad908541c6"
SECTION = "bootloader"
PROVIDES = "u-boot-fw-utils"
RPROVIDES_${PN} = "u-boot-fw-utils"
DEPENDS = "mtd-utils"

COMPATIBLE_MACHINE = "pico-imx6ul"

UBOOT_SRC ?= "git://github.com/TechNexion/u-boot-edm.git"
SRCBRANCH = "tn-imx_v2017.03_4.9.88_2.0.0_ga-test"
SRC_URI = " \
    ${UBOOT_SRC};branch=${SRCBRANCH} \
    file://0001-tools-fix-cross-compiling-tools-when-HOSTCC-is-overr.patch \
    file://fw_env.config \
"
SRCREV = "2fb0ee63229919807737b83d49f5813f594939ac"

S = "${WORKDIR}/git"

INSANE_SKIP_${PN} = "already-stripped"
EXTRA_OEMAKE_class-target = 'CROSS_COMPILE=${TARGET_PREFIX} CC="${CC} ${CFLAGS} ${LDFLAGS}" HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}" V=1'
EXTRA_OEMAKE_class-cross = 'ARCH=${TARGET_ARCH} CC="${CC} ${CFLAGS} ${LDFLAGS}" V=1'

inherit pkgconfig uboot-config

do_compile () {
    oe_runmake ${UBOOT_MACHINE}
    oe_runmake env
}

do_install () {
    install -d ${D}${base_sbindir} ${D}${sysconfdir}
    install -m 755 ${S}/tools/env/fw_printenv ${D}${base_sbindir}/fw_printenv
    ln -s fw_printenv ${D}${base_sbindir}/fw_setenv
    install -m 644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/
}

do_install_class-cross () {
	install -d ${D}${bindir_cross}
	install -m 755 ${S}/tools/env/fw_printenv ${D}${bindir_cross}/fw_printenv
	install -m 755 ${S}/tools/env/fw_printenv ${D}${bindir_cross}/fw_setenv
}

do_deploy () {
}

SYSROOT_DIRS_append_class-cross = " ${bindir_cross}"

PACKAGE_ARCH = "${MACHINE_ARCH}"
require u-boot-mender-edm.inc
