EXTRA_OECONF:append = "${@' --with-extended-sector-count=1' if bb.utils.to_boolean(d.getVar('TEGRA_MENDER_BOOTINFO_STORAGE_REDUCE')) else ''}"
