# Add a slotted A/B partition layout for the Uno Q by deriving it from the stock
# emmc-16GB layout: replace the single grow-to-end `rootfs` with two equal
# `system_a`/`system_b` slots (named `system_*` so qbootctl manages their GPT AB
# bits) plus a grow-to-end `userdata`. Both system slots reference rootfs.img, so
# the single built rootfs image is written to both at flash time (both slots
# provisioned). Selected via QCOM_PARTITION_FILES_SUBDIR = partitions/qrb2210-unoq/system-ab.

do_compile:prepend() {
    src="${S}/platforms/qrb2210-unoq/emmc-16GB/partitions.conf"
    dst="${S}/platforms/qrb2210-unoq/system-ab"
    if [ -f "$src" ]; then
        mkdir -p "$dst"
        # drop the single rootfs partition, keep everything else (incl. --grow-last-partition on --disk)
        sed '/--name=rootfs /d' "$src" > "$dst/partitions.conf"
        # dtbo_a/dtbo_b: qbootctl's set-active path treats boot_a and dtbo_a as
        # hard-required (others are skipped if absent). We have boot_a/b but no
        # dtbo, so add a small dtbo pair so `qbootctl -s` succeeds. system_a/b are
        # the OS slots; userdata (last, grows to fill) is persistent.
        cat >> "$dst/partitions.conf" <<'PARTS'
--partition --name=dtbo_a --size=8192KB --type-guid=24D0D418-D31D-4D8D-AC2C-4D4305188450
--partition --name=dtbo_b --size=8192KB --type-guid=24D0D418-D31D-4D8D-AC2C-4D4305188450
--partition --name=system_a --size=5242880KB --type-guid=B921B045-1DF0-41C3-AF44-4C6F280D3FAE --filename=rootfs.img
--partition --name=system_b --size=5242880KB --type-guid=B921B045-1DF0-41C3-AF44-4C6F280D3FAE --filename=rootfs.img
--partition --name=userdata --size=2145728KB --type-guid=0FC63DAF-8483-4772-8E79-3D69D8477DE4
PARTS
    fi
}
