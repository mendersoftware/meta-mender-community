inherit image_types_tegra

DATAFILE ?= "${IMAGE_BASENAME}-${MACHINE}.dataimg"

tegraflash_custom_pre() {
    # Target needs to match install target in IMAGE_CMD_dataimg
    ln -s ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.dataimg ./${DATAFILE}
}

tegraflash_create_flash_config_append() {
    sed -i \
        -e"s,DATAFILE,${DATAFILE}," \
        flash.xml.in
}
