ARMFILESPATHS_MENDER := "${THISDIR}/${PN}:"

FILESEXTRAPATHS:prepend:qemuarm64 = "${ARMFILESPATHS_MENDER}"
SRC_URI:append:qemuarm64 = " file://efi.cfg"

FILESEXTRAPATHS:prepend:qemuarm = "${ARMFILESPATHS_MENDER}"
SRC_URI:append:qemuarm = " file://efi.cfg"