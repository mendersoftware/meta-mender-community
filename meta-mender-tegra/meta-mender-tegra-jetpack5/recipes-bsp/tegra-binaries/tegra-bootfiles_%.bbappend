
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

    nvflashxmlparse -v --rewrite-contents-from=${WORKDIR}/UDA.xml --output=${D}${datadir}/tegraflash/${PARTITION_LAYOUT_TEMPLATE}.patched ${D}${datadir}/tegraflash/${PARTITION_LAYOUT_TEMPLATE}
    mv ${D}${datadir}/tegraflash/${PARTITION_LAYOUT_TEMPLATE}.patched ${D}${datadir}/tegraflash/${PARTITION_LAYOUT_TEMPLATE}

    nvflashxmlparse -v --rewrite-contents-from=${WORKDIR}/UDA.xml --output=${D}${datadir}/tegraflash/${PARTITION_LAYOUT_EXTERNAL}.patched ${D}${datadir}/tegraflash/${PARTITION_LAYOUT_EXTERNAL}
    mv ${D}${datadir}/tegraflash/${PARTITION_LAYOUT_EXTERNAL}.patched ${D}${datadir}/tegraflash/${PARTITION_LAYOUT_EXTERNAL}
}
