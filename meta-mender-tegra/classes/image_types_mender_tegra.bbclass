inherit image_types_tegra

DATAFILE ?= "${IMAGE_BASENAME}-${MACHINE}.dataimg"

tegraflash_custom_pre() {
    # Target needs to match install target in IMAGE_CMD_dataimg
    ln -s ${IMGDEPLOYDIR}/${IMAGE_LINK_NAME}.dataimg ./${DATAFILE}
}

tegraflash_generate_bupgen_script_append() {
    sed -i -e"1a sed -i -e'/DATAFILE/d' ./flash.xml.in" $outfile
}

tegraflash_custom_post_append() {
    sed -i -e"s,DATAFILE,${DATAFILE}," ${WORKDIR}/tegraflash/flash.xml.in
}
