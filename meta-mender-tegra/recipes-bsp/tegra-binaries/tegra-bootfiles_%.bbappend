MENDER_DEP = "mender-custom-flash-layout"
MENDER_DEP_jetson-nano = ""
MENDER_PARTITION_FILE = "${STAGING_DATADIR}/mender-flash-layout/flash_mender.xml"
MENDER_PARTITION_FILE_jetson-nano = ""
DEPENDS += "${MENDER_DEP}"

python() {
    mender_partfile = d.getVar('MENDER_PARTITION_FILE')
    if mender_partfile:
        d.setVar('PARTITION_FILE', mender_partfile)
}
