inherit image_types_tegra

DATAFILE ?= "${IMAGE_BASENAME}-${MACHINE}.dataimg"

tegraflash_custom_pre() {
    # Target needs to match install target in IMAGE_CMD_dataimg
    ln -s ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.dataimg ./${DATAFILE}
}

tegraflash_create_flash_config_append() {
    sed -i \
        -e"s,DATAFILE,${DATAFILE}," \
        $destdir/flash.xml.in
    if [ "${TEGRA_SPIFLASH_BOOT}" = "1" ]; then
        sed -i \
            -e"s,DATAFILE,${DATAFILE}," \
	   $destdir/sdcard.xml.in $destdir/sdcard-layout
        sed -i \
            -e"s,APPSIZE,${ROOTFSPART_SIZE}," \
	   $destdir/sdcard-layout
    fi
}
