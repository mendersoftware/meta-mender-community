This layer holds the Tegra-native update scheme: a `tegra-rootfs-image` update
module that drives `nvbootctrl`, the BSP partlabels and the UEFI capsule
directly, instead of Mender's stock `rootfs-image` module and the adapters that
one needs on Tegra.

It is one of two mutually exclusive scheme layers, and selecting it means adding
it to `BBLAYERS` and inheriting `tegra-mender-native`.

See ../README.md for more details and other layers.
