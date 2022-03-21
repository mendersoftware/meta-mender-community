addhandler odroid_bbappend_layercheck
odroid_bbappend_layercheck[eventmask] = "bb.event.SanityCheck"
python odroid_bbappend_layercheck() {
    bb.fatal("The layer meta-mender-odroid has been automatically \
syntax converted and is not validated for kirkstone yet. Please disable \
this message, verify correct operation and submit a PR removing the \
sanity check.")
}
