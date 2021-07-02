FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_remove_mender-client-install_apalis-imx6 = " file://0002-apalis-imx6-test-for-Capacitive-Touch-Display-7-Para.patch "
SRC_URI_append_mender-client-install_apalis-imx6 = " file://0002-apalis-imx6-test-for-Capacitive-Touch-Display-7-Para-with-mender.patch "
