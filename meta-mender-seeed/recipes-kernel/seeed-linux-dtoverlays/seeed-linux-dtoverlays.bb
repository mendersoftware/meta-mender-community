SUMMARY = "seeed reterminal device tree overlay"
DESCRIPTION = "include all the device dtoverlay of reterminal"
HOMEPAGE = "https://github.com/Seeed-Studio/seeed-linux-dtoverlays"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

inherit linux-kernel-base module-base

KERNEL_VERSION = "${@get_kernelversion_file("${STAGING_KERNEL_BUILDDIR}")}"

SRCREV = "8605f1ca151d4e225dc2716cb4035a5c5f727257"

SRC_URI = " \
	git://github.com/Seeed-Studio/seeed-linux-dtoverlays.git;protocol=https;branch=master \
	file://0001-compatible-for-yocto.patch \
"

DEPENDS += "dtc-native"

S = "${WORKDIR}/git"

INSANE_SKIP:${PN} = "file-rdeps"

do_compile() {
	oe_runmake \
		ARCH=${ARCH} \
		KBUILD=${STAGING_KERNEL_DIR} \
		O=${STAGING_KERNEL_BUILDDIR} \
		CROSS_COMPILE=${TARGET_PREFIX} \
		all_rpi
}

do_install() {
	install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/
	oe_runmake \
		ARCH=${ARCH} \
		KBUILD=${STAGING_KERNEL_DIR} \
		CROSS_COMPILE=${TARGET_PREFIX} \
		KO_DIR=${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/ \
		install_rpi
}

FILES:${PN} += "${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/*"
