addhandler toradex_nxp_bbappend_layercheck
toradex_nxp_bbappend_layercheck[eventmask] = "bb.event.SanityCheck"
python toradex_nxp_bbappend_layercheck() {
    bb.fatal("The layer meta-mender-toradex-nxp has been automatically \
syntax converted and is not validated for kirkstone yet. Please disable \
this message, verify correct operation and submit a PR removing the \
sanity check.")
}
