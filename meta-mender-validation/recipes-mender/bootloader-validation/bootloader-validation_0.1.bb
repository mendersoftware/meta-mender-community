SUMMARY = "Mender bootloader validation"
DESCRIPTION = "Automated validation of the Mender bootloader integration"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/theyoctojester/mender-validation.git;protocol=https;branch=main"
SRCREV = "8e9ed9f22b1a7e193dbb0ce93c27ff2b2d9e804b"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

# per developer definition, the validation scripts are allowed to use the full
# python3 standard library unconditionally. This RDEPENDS reflects this to not
# break upon future extensions.
RDEPENDS:${PN} = "python3"

inherit systemd
SYSTEMD_SERVICE:${PN} = "mender-bootloader-validation.service"

S = "${WORKDIR}/git"

do_install() {
    if ${@bb.utils.contains('MENDER_FEATURES', 'mender-prepopulate-inactive-partition', 'false', 'true', d)}; then
        bbwarn "MENDER_FEATURES does not contain 'mender-prepopulate-inactive-partition', validation suite will probably not be functional."
    fi

    install -d ${D}${datadir}/mender-validation
    install -m 0755 ${S}/mender-bootloader-validation.py ${D}${datadir}/mender-validation/mender-bootloader-validation.py

    install -d ${D}/${systemd_unitdir}/system
    install -m 0644 ${S}/support/mender-bootloader-validation.service ${D}/${systemd_unitdir}/system
}

FILES:${PN} += "${datadir}/mender-validation/mender-bootloader-validation.py"
