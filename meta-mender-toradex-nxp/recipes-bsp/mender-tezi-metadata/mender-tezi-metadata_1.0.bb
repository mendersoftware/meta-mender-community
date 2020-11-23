DESCRIPTION = "Toradex Easy Installer Metadata"

inherit deploy

SRC_URI = " \
    file://prepare.sh \
    file://wrapup.sh \
    file://mender_toradex_linux.png \
    file://marketing_mender_toradex.tar;unpack=false \
"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

do_deploy() {
    install -d ${DEPLOYDIR}/mender-tezi-metadata
    install -m 644 ${WORKDIR}/prepare.sh ${DEPLOYDIR}/mender-tezi-metadata
    install -m 644 ${WORKDIR}/wrapup.sh ${DEPLOYDIR}/mender-tezi-metadata
    install -m 644 ${WORKDIR}/mender_toradex_linux.png ${DEPLOYDIR}/mender-tezi-metadata
    install -m 644 ${WORKDIR}/marketing_mender_toradex.tar ${DEPLOYDIR}/mender-tezi-metadata
}
addtask do_deploy after do_compile

