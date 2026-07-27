This layer holds Jetpack 6 parts of the Mender integration for Tegra.

It is kept for reference only. It declares `LAYERSERIES_COMPAT` `scarthgap`, so
bitbake will not load it in a wrynose build, and its kernel bbappend targets
`linux-jammy-nvidia-tegra`, which meta-tegra's `wrynose` branch does not carry.
For a working Jetpack 6 build, use the `scarthgap` branch of this repository.

See ../README.md for more details and other layers.
