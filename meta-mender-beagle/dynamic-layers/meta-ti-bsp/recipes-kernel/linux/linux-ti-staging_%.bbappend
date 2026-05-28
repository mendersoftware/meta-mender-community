FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

# BeaglePlay's RJ45 PHY is a Realtek RTL8211F; without the upstream
# CONFIG_REALTEK_PHY (and friends) being in the linux-ti-staging defconfig,
# the kernel falls back to the generic PHY driver and link never comes up.
# Long-term fix is for meta-ti to enable these by default; this fragment
# patches around it in the meantime.
SRC_URI:append:beagleplay-ti = " file://cfg/beagleplay-ethernet.cfg"
KERNEL_CONFIG_FRAGMENTS:append:beagleplay-ti = " ${UNPACKDIR}/cfg/beagleplay-ethernet.cfg"
