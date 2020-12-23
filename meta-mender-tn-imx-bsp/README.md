# meta-mender-tn-imx-bsp

Mender integration layer for TechNexion family of boards.

The supported and tested boards are:

- [PICO-IMX8M](https://hub.mender.io/t/technexion-pico-imx8m/)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on [TechNexion Yocto 2.5 Sumo 4.14.y GA BSP](https://github.com/TechNexion/tn-imx-yocto-manifest/tree/sumo_4.14.y_GA-stable)


## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir mender-tn-imx-bsp && cd mender-tn-imx-bsp
repo init -u https://github.com/TechNexion/tn-imx-yocto-manifest.git -b sumo_4.14.y_GA-stable -m imx-4.14.98-2.0.1_patch.xml
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/mendersoftware/meta-mender-community/sumo/meta-mender-tn-imx-bsp/scripts/mender-technexion.xml
repo sync -j$(nproc)
DISTRO=fsl-imx-xwayland MACHINE=pico-imx8mq source tn-setup-mender.sh -b build-xwayland-imx8mq
bitbake core-image-base
```


## Maintainer

The authors and maintainers of this layer are:

- Tom Rini <trini@konsulko.com>

Always include the maintainers when suggesting code changes to this layer.
