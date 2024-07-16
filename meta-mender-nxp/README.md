# meta-mender-nxp

Mender integration for nxp based boards

The supported and tested boards are:

 - [Olimex iMX8MP-SOM-4GB-IND and iMX8MP-SOM-EVB-IND](https://www.olimex.com/Products/SOM/NXP-iMX8/)


Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://github.com/Freescale/meta-freescale
branch: scarthgap
revision: HEAD
```

```
URI: https://github.com/Freescale/meta-freescale-3rdparty
branch: scarthgap
revision: HEAD
```

```
URI: https://github.com/Freescale/meta-freescale-distro
branch: scarthgap
revision: HEAD
```

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir -p meta-mender-community/mender-nxp && cd meta-mender-community/mender-nxp
kas build ../kas/olimex-imx8mp-evb.yml
```


