# meta-mender-tegra

Mender integration layer for NVIDIA Tegra hardware.
 
The supported and tested boards are:

- [Jetson TX2](https://hub.mender.io/t/nvidia-tegra-jetson-tx2/123)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.


## Dependencies

This layer depends on:

```
URI: https://github.com/madisongh/meta-tegra.git
layers: meta-tegra
branch: warrior
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: warrior
revision: HEAD
```


## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir mender-tegra && cd mender-tegra
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-tegra/scripts/manifest-tegra.xml \
           -b warrior
repo sync
source setup-environment tegra
MACHINE=jetson-tx2 bitbake core-image-base
```


## Maintainer

The author and maintainer of this layer is:

- Dan Walkes - <danwalkes@trellis-logic.com> - [dwalkes](https://github.com/dwalkes)

Always include the maintainers when suggesting code changes to this layer.
