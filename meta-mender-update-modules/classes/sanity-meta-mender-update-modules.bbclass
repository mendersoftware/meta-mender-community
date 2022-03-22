addhandler update_modules_bbappend_layercheck
update_modules_bbappend_layercheck[eventmask] = "bb.event.SanityCheck"
python update_modules_bbappend_layercheck() {
    bb.fatal("The layer meta-mender-update-modules has been automatically \
syntax converted and is not validated for kirkstone yet. Please disable \
this message, verify correct operation and submit a PR removing the \
sanity check.")
}
