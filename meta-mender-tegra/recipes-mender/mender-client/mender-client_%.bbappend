RDEPENDS_${PN}_append_tegra = "${@' tegra-bup-payload u-boot-fw-utils-fake' if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot') else ''}"
