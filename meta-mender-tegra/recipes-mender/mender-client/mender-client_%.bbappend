RDEPENDS_${PN}_append_tegra = "${@' tegra-bup-payload libubootenv-fake' if d.getVar('PREFERRED_PROVIDER_virtual/bootloader').startswith('cboot') else ''}"
