# meta-mender-nxp

Mender integration for nxp based boards

The supported and tested boards are:

 - [WaRP7](https://hub.mender.io/t/nxp-warp7/135)
 - [Pico-Pi i.MX7D](https://hub.mender.io/t/technexion-pico-pi-imx7/136)
 - [Nitrogen8M](https://hub.mender.io/t/boundary-devices-nitrogen8m/409)


Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://github.com/Freescale/meta-freescale-3rdparty
branch: warrior
revision: HEAD
```

```
URI: https://github.com/Freescale/meta-freescale-distro
branch: warrior
revision: HEAD
```

```
URI: https://github.com/boundarydevices/meta-boundary
branch: master
revision: 14d7a54464450e50bdd28b6cba505d1263bc1b41
```

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir mender-nxp && cd mender-nxp
repo init -u https://github.com/mendersoftware/meta-mender-community \
          -m meta-mender-nxp/scripts/manifest-nxp.xml \
          -b warrior
repo sync
source setup-environment nxp
MACHINE=imx7s-warp bitbake core-image-base
```


## Maintainer

The author(s) and maintainer(s) of this layer are:

- Pierre-Jean Texier - <pjtexier@koncepto.io> - [texierp](https://github.com/texierp)
- Joris Offouga - <offougajoris@gmail.com> - [jorisoffouga](https://github.com/jorisoffouga)

Always include the maintainers when suggesting code changes to this layer.
