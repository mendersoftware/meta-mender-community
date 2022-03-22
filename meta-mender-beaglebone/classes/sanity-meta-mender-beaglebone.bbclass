addhandler beaglebone_bbappend_layercheck
beaglebone_bbappend_layercheck[eventmask] = "bb.event.SanityCheck"
python beaglebone_bbappend_layercheck() {
    bb.fatal("The layer meta-mender-beaglebone has been automatically \
syntax converted and is not validated for kirkstone yet. Please disable \
this message, verify correct operation and submit a PR removing the \
sanity check.")
}
