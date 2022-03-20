FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

include ${@mender_feature_is_enabled("mender-uboot","recipes-bsp/u-boot/u-boot-mender.inc","",d)}

SRC_URI += "file://mender.cfg"
