# meta-mender-nxp

Mender integration for nxp based boards

The supported and tested boards are:

 - [WaRP7](https://hub.mender.io/t/nxp-warp7/135)
 - [Pico-Pi i.MX7D](https://hub.mender.io/t/technexion-pico-pi-imx7/136)
 - [Nitrogen8M](https://hub.mender.io/t/boundary-devices-nitrogen8m/409)
 - [Nitrogen8MM](https://hub.mender.io/t/boundary-devices-nitrogen8m/409)
 - [Nitrogen8MN](https://hub.mender.io/t/boundary-devices-nitrogen8m/409)
 - [Nitrogen8MP](https://hub.mender.io/t/boundary-devices-nitrogen8m/409)
 - [i.MX7D SABRE](https://hub.mender.io/t/nxp-i-mx7d-sabre/1279)
 - [HummingBoard i.MX6 SBC](https://hub.mender.io/t/solidrun-hummingboard-and-cubox-i/5671)


Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://github.com/Freescale/meta-freescale-3rdparty
branch: kirkstone
revision: HEAD
```

```
URI: https://github.com/Freescale/meta-freescale-distro
branch: kirkstone
revision: HEAD
```

```
URI: https://github.com/boundarydevices/meta-boundary
branch: kirkstone
revision: HEAD
```

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir mender-nxp && cd mender-nxp
repo init -u https://github.com/mendersoftware/meta-mender-community \
          -m meta-mender-nxp/scripts/manifest-nxp.xml \
          -b kirkstone
repo sync
source setup-environment nxp
MACHINE=imx7s-warp bitbake core-image-base
```


