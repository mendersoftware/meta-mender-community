addhandler toradex_nxp_bbappend_layercheck
toradex_nxp_bbappend_layercheck[eventmask] = "bb.event.SanityCheck"
python toradex_nxp_bbappend_layercheck() {
    bb.warn("The layer meta-mender-toradex-nxp has been tested only \
against the MACHINE support provided by meta-freescale-3rdparty. \
Toradex does not yet have support in their layers for the Kirkstone \
branch so your mileage may vary. The biggest obvious missing feature \
is the Toradex Easy Installer support; as is, there is no easy or \
documented method to install images built with this layer.")
}
