FILESEXTRAPATHS:prepend_mender-uboot := "${THISDIR}/files:${THISDIR}/files/${TORADEX_BSP_VERSION}:"

SRC_URI += "file://0001-Adapt-boot.cmd.in-to-Mender.patch;patchdir=${WORKDIR};striplevel=0"