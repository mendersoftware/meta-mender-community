# meta-mender-tegra

Mender integration layer for NVIDIA Tegra hardware.

The supported and tested boards are:

- [Jetson TX2](https://hub.mender.io/t/nvidia-tegra-jetson-tx2/123)
- [Jetson Nano](https://hub.mender.io/t/nvidia-tegra-jetson-nano/1360)
- Jetson Xavier - No mender hub page for this yet, but known working as of the Zeus branch.  If anyone would
like to volunteer to maintain this hardware platform please [contact me](https://github.com/dwalkes)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.


## Dependencies

This layer depends on:

```
URI: https://github.com/madisongh/meta-tegra.git
layers: meta-tegra
branch: zeus-l4t-r32.3.1
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: zeus
revision: HEAD
```


## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir mender-tegra && cd mender-tegra
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-tegra/scripts/manifest-tegra.xml \
           -b zeus
repo sync
source setup-environment tegra
```

Finally, run the build with a command like:

```
MACHINE=jetson-tx2 bitbake core-image-base
or:
MACHINE=jetson-nano bitbake core-image-base
or
MACHINE=jetson-nano-qspi-sd bitbake core-image-base
```

depending on the hardware platform in use.  See [meta-tegra release notes](https://github.com/madisongh/meta-tegra/wiki/L4T-R32.3.1-Notes) for details.

## Maintainer

The author and maintainer of this layer is:

- Dan Walkes - <danwalkes@trellis-logic.com> - [dwalkes](https://github.com/dwalkes)

Always include the maintainers when suggesting code changes to this layer.

## Acknowlegements

Special thanks to [Matt Madison](https://github.com/madisongh) for his contributions to support zeus and later branches,
and his work on meta-tegra which makes this mender integration possible.
