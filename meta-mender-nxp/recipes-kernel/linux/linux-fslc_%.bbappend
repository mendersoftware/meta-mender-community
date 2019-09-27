FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_imx7d-pico = " \
	file://0001-linux-fslc-imx7d-pico-Disable-panel.patch \
"
