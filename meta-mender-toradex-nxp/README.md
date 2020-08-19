# meta-mender-toradex-nxp

Mender integration layer for Toradex family of boards.

The supported and tested boards are:

- [apalis-imx6](https://hub.mender.io/t/toradex-nxp-i-mx-6-computer-on-module-apalis-imx6/2331)
- [colibri-imx7](https://hub.mender.io/t/toradex-colibri-imx7-dual-512mb-colibri-imx7-solo-256mb/81)
- [colibri-imx7-emmc](https://hub.mender.io/t/toradex-colibri-imx7-dual-1gb/131)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://git.toradex.com/meta-toradex-nxp.git
branch: zeus
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
mkdir mender-toradex && cd mender-toradex
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-toradex/scripts/manifest-toradex.xml \
           -b zeus
repo sync
source setup-environment 
MACHINE=colibri-imx7-emmc bitbake core-image-base
```


## Maintainer

The authors and maintainers of this layer are:

- Mirza Krak - <mirza.krak@northern.tech> - [mirzak](https://github.com/mirzak)
- Drew Moseley - <drew.moseley@northern.tech> - [drewmoseley](https://github.com/drewmoseley)

Always include the maintainers when suggesting code changes to this layer.
