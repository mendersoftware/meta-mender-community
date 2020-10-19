# meta-mender-imx

Mender integration for NXP i.MX BSP based boards

The supported and tested boards are:

 - [NXP® i.MX 8MNano Applications Processor Evaluation Kit](https://hub.mender.io/t/nxp-i-mx-8mnano-evaluation-kit/2690)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on NXP BSP `imx-5.4.3-2.0.0` as well as

```
URI: https://github.com/mendersoftware/meta-mender
branch: zeus
revision: HEAD
```


## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir mender-imx && cd mender-imx
repo init -u https://github.com/mendersoftware/meta-mender-community \
          -m meta-mender-imx/scripts/imx-5.4.3-2.0.0_demo_mender.xml \
          -b zeus
repo sync
DISTRO=fsl-imx-xwayland MACHINE=imx8mnevk . imx-setup-mender.sh -b build
MACHINE=imx8mnevk bitbake core-image-base
```


## Maintainer

The author(s) and maintainer(s) of this layer are:

- Drew Moseley - <drew.moseley@northern.tech> - [drewmoseley](https://github.com/drewmoseley)

Always include the maintainers when suggesting code changes to this layer.
