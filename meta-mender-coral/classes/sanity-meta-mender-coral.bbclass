addhandler coral_bbappend_layercheck
coral_bbappend_layercheck[eventmask] = "bb.event.SanityCheck"
python coral_bbappend_layercheck() {
    bb.fatal("The layer meta-mender-coral has been automatically \
syntax converted and is not validated for kirkstone yet. Please disable \
this message, verify correct operation and submit a PR removing the \
sanity check.")
}
