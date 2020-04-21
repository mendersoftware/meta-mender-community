RDEPENDS_${PN}_append_tegra = "${@' mender-tegra-bup-payload-install u-boot-fw-utils-fake' if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot') else ''}"
