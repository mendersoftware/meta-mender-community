FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# zynq-arty-z7-20.dts (CONFIG_DTFILE, set in the machine conf) includes the
# kernel's zynq-7000.dtsi and dt-bindings headers; device-tree.bb defaults
# KERNEL_INCLUDE to empty, so restore the devicetree.bbclass kernel paths.
KERNEL_INCLUDE:arty-z7-20 = " \
    ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts \
    ${STAGING_KERNEL_DIR}/arch/${ARCH}/boot/dts/* \
    ${STAGING_KERNEL_DIR}/scripts/dtc/include-prefixes \
    "
