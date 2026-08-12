# meta-mender-tegra-classic

The classic Tegra update scheme: Mender's stock `rootfs-image` update module,
driven through this layer's state scripts and the `fw_printenv`/`fw_setenv`
shims.

One of two mutually exclusive scheme layers. Select it by adding it to
`BBLAYERS` and `INHERIT += "tegra-mender-classic"`.

See ../README.md for the layer set as a whole.
