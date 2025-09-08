require u-boot-raspberrypi.inc
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-Adding-boot-delay-2.patch"

