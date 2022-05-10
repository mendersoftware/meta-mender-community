# meta-mender-toradex-nxp

Mender integration layer for Toradex family of boards.

The supported and tested boards are:

- [Toradex Verdin iMX8M Mini](https://hub.mender.io/t/toradex-verdin-imx8m-mini/2908)
- [Toradex Verdin iMX8M Plus](https://hub.mender.io/t/toradex-verdin-imx8m-plus/5026)
- [Toradex Colibri i.MX6ULL](https://hub.mender.io/t/toradex-colibri-i-mx6ull/4102/2)
- [Apalis i.MX6](https://hub.mender.io/t/toradex-nxp-i-mx-6-computer-on-module-apalis-imx6/2331)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://github.com/Freescale/meta-freescale-3rdparty.git
branch: kirkstone
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: kirkstone
revision: HEAD
```

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.

TBD

## Notes for colibri-imx6ull
- Current mender integration uses ubi volumes to store the redundant environment, this is why the regular u-boot-env partition has been removed from the MTDPARTS


