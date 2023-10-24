do_configure:prepend() {
	if [ -n "${MENDER_FEATURES}" ]; then
		bbwarn "having both the Mender integration and the meta-mender-client-only layer enabled will cause unexpected effects!"
	fi
}

do_compile:append() {
    echo "device_type=${MACHINE}" > ${B}/device_type
}

do_install:append() {
    install -m 755 -d ${D}/${localstatedir}/lib/mender
    install -m 444 ${B}/device_type ${D}/${localstatedir}/lib/mender/
}

RDEPENDS:${PN} = " ca-certificates"