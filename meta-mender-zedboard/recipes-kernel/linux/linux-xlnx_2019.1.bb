LINUX_VERSION = "4.19"
XILINX_RELEASE_VERSION = "v2019.1"
KBRANCH ?= "xlnx_rebase_v4.19"
SRCREV ?= "9811303824b66a8db9a8ec61b570879336a9fde5"

include linux-xlnx.inc

FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += "file://0001-compile-my-devicetree.patch"

#SRC_URI += "file://system-top.dts;subdir=git/arch/${ARCH}/boot/dts"
#SRC_URI += "file://pcw.dtsi;subdir=git/arch/${ARCH}/boot/dts"
#SRC_URI += "file://pl.dtsi;subdir=git/arch/${ARCH}/boot/dts"
#SRC_URI += "file://zynq-7000.dtsi;subdir=git/arch/${ARCH}/boot/dts"

