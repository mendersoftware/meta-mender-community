FILESEXTRAPATHS_prepend_mender-uboot := "${THISDIR}/files:"

SRC_URI += "file://0001-Adapt-boot.cmd.in-to-Mender.patch;patchdir=${WORKDIR};striplevel=1"