MENDER_DEP = "mender-custom-flash-layout"
MENDER_PARTITION_FILE = "${STAGING_DATADIR}/mender-flash-layout/flash_mender.xml"
DEPENDS += "${MENDER_DEP}"

python() {
    mender_partfile = d.getVar('MENDER_PARTITION_FILE')
    if mender_partfile:
        d.setVar('PARTITION_FILE', mender_partfile)
}
