addhandler tegra_bbappend_layercheck
tegra_bbappend_layercheck[eventmask] = "bb.event.SanityCheck"
python tegra_bbappend_layercheck() {
    bb.fatal("The layer meta-mender-tegra has been automatically \
syntax converted and is not validated for kirkstone yet. Please disable \
this message, verify correct operation and submit a PR removing the \
sanity check.")
}
