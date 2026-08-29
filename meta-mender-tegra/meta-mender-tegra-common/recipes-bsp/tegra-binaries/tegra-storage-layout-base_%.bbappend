DEPENDS:append = " tegra-helper-scripts-native"
PATH =. "${STAGING_BINDIR_NATIVE}/tegra-flash:"

# Size of the data partition in the staged flash layout.
#
# NVIDIA's templates hardcode it (400MB UDA on t234) and nothing carries
# MENDER_DATA_PART_SIZE_MB into the layout, so three values disagree: the
# layout allocates 400MB, mender's accounting and its flashed ext4 data image
# follow MENDER_DATA_PART_SIZE_MB (default 128), and the first-boot growfs
# expands the filesystem to fill the partition -- which makes the default
# arrangement look coherent by accident. Raising MENDER_DATA_PART_SIZE_MB
# breaks it: the data image no longer fits the partition it is flashed into.
#
# Set empty to keep the template's size, leaving the staged layouts
# byte-identical to before.
TEGRA_MENDER_UDA_SIZE_MB ?= "${@d.getVar('MENDER_DATA_PART_SIZE_MB') or ''}"

mender_flash_layout_adjust() {
    local file=$1
    mv ${D}${datadir}/l4t-storage-layout/$file ${WORKDIR}/$file
    nvflashxmlparse -v --rewrite-contents-from=${WORKDIR}/UDA.xml \
		--output=${WORKDIR}/$file.contents \
		${WORKDIR}/$file
    if [ -s ${WORKDIR}/UDA-size.xml ]; then
        nvflashxmlparse -v --update-parttype-sizes-from=${WORKDIR}/UDA-size.xml:data \
		--output=${D}${datadir}/l4t-storage-layout/$file \
		${WORKDIR}/$file.contents
    else
        mv ${WORKDIR}/$file.contents ${D}${datadir}/l4t-storage-layout/$file
    fi
}

do_install:append() {
    cat <<EOF >${WORKDIR}/UDA.xml
<partition_layout>
    <device>
        <partition name="UDA">
            <filename> DATAFILE </filename>
        </partition>
    </device>
</partition_layout>
EOF

    rm -f ${WORKDIR}/UDA-size.xml
    if [ -n "${TEGRA_MENDER_UDA_SIZE_MB}" ]; then
        uda_bytes=$(expr ${TEGRA_MENDER_UDA_SIZE_MB} \* 1024 \* 1024)
        cat <<EOF >${WORKDIR}/UDA-size.xml
<partition_layout>
    <device>
        <partition name="UDA">
            <size> $uda_bytes </size>
        </partition>
    </device>
</partition_layout>
EOF
    fi

    mender_flash_layout_adjust "${PARTITION_LAYOUT_TEMPLATE}"
    mender_flash_layout_adjust "${PARTITION_LAYOUT_EXTERNAL}"
    chown -R root:root ${D}
}
