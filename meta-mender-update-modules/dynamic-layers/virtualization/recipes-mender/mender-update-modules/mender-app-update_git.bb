DESCRIPTION = "Mender Application Update Module for supporting containerized application updates on devices including related tools ."

HOMEPAGE = "https://mender.io"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b4b4cfdaea6d61aa5793b92efd42e081"

SRC_URI = "git://github.com/mendersoftware/app-update-module;branch=master;protocol=https"

SRCREV = "c9f28c6c6a8c4cfb5297520c0da832177be87002"

S = "${WORKDIR}/git"

RDEPENDS:${PN} = "docker-compose jq mender-update xdelta3"

inherit allarch

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install:class-target() {
	# install Application Update Module
    install -d ${D}/${datadir}/mender/modules/v3
    install -m 755 ${S}/src/app ${D}/${datadir}/mender/modules/v3/app

	# install Docker Compose Module
    install -d ${D}/${datadir}/mender/app-modules/v1
    install -m 755 ${S}/src/app-modules/docker-compose ${D}/${datadir}/mender/app-modules/v1/docker-compose

	# install configuration files
    install -d ${D}/${sysconfdir}/mender
    install -m 755 ${S}/conf/mender-app.conf ${D}/${sysconfdir}/mender/mender-app.conf
    install -m 755 ${S}/conf/mender-app-docker-compose.conf ${D}/${sysconfdir}/mender/mender-app-docker-compose.conf
}

do_install:class-native() {
    install -d ${D}/${bindir}
    install -m 755 ${S}/gen/app-gen ${D}/${bindir}/app-gen
}

FILES:${PN} += "${datadir}/mender/modules/v3/app"
FILES:${PN} += "${datadir}/mender/app-modules/v1/docker-compose"

FILES:${PN}-class-native += "${bindir}/dir-overlay-artifact-gen"

BBCLASSEXTEND = "native"
