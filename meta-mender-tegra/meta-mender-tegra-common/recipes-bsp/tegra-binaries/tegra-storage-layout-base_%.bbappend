DEPENDS:append = " tegra-helper-scripts-native"
PATH =. "${STAGING_BINDIR_NATIVE}/tegra-flash:"

mender_flash_layout_adjust() {
    local file=$1
    mv ${D}${datadir}/l4t-storage-layout/$file ${WORKDIR}/$file
    nvflashxmlparse -v --rewrite-contents-from=${WORKDIR}/UDA.xml \
		--output=${D}${datadir}/l4t-storage-layout/$file \
		${WORKDIR}/$file
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

    mender_flash_layout_adjust "${PARTITION_LAYOUT_TEMPLATE}"
    mender_flash_layout_adjust "${PARTITION_LAYOUT_EXTERNAL}"
    chown -R root:root ${D}
}
