require recipes-bsp/u-boot/u-boot-mender.inc
require u-boot-mender-toradex-nxp.inc

# The meta-boot2qt layer adds a patch that requires us to select a different
# integration patch.  To further complicate things, it does not add that
# patch for u-boot-toradex-fsl-fw-utils so we have to handle that recipe
# differently
SRC_URI_append_apalis-imx6 = " \
    ${@bb.utils.contains('BBFILE_COLLECTIONS', 'b2qt', \
    'file://0001-apalis-imx6-mender-integration-patch-with-boot2qt.patch', \
    'file://0001-apalis-imx6-mender-integration-patch.patch', \
    d)} \
"
