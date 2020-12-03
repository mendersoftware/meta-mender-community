# meta-mender-tn-imx-bsp

Mender integration layer for TechNexion family of boards.

The supported and tested boards are:

- [PICO-PI-IMX8M-MINI](https://hub.mender.io/t/technexion-pico-pi-imx8m-mini/2689)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on [TechNexion Yocto 3.0 Zeus 5.4.y GA BSP](https://github.com/TechNexion/tn-imx-yocto-manifest/tree/zeus_5.4.y-next)


## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir mender-tn-imx-bsp && cd mender-tn-imx-bsp
repo init -u https://github.com/TechNexion/tn-imx-yocto-manifest.git -b zeus_5.4.y-next -m imx-5.4.47-2.2.0.xml
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/mendersoftware/meta-mender-community/zeus/meta-mender-tn-imx-bsp/scripts/mender-technexion.xml
repo sync -j$(nproc)
DISTRO=fsl-imx-xwayland MACHINE=pico-imx8mm source tn-setup-mender.sh -b build-xwayland-imx8mm
bitbake core-image-base
```


## Maintainer

The authors and maintainers of this layer are:

- Mirza Krak - <mirza.krak@northern.tech> - [mirzak](https://github.com/mirzak)

Always include the maintainers when suggesting code changes to this layer.
