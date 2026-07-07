# Mount the persistent userdata partition at /data (auto-mkfs on first use).
# Mender's state is relocated here (see unoq-mender-persist) so device identity
# and in-flight update state survive the A/B rootfs swap. nofail so a data-part
# hiccup never drops the system to emergency mode.
do_install:append() {
    printf '%-24s %-10s %-6s %-40s %s\n' \
        "PARTLABEL=userdata" "/data" "ext4" "defaults,x-systemd.makefs,nofail,x-systemd.growfs" "0 2" \
        >> ${D}${sysconfdir}/fstab
}
