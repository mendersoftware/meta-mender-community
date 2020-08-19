# meta-mender-sunxi

Mender integration layer for Sunxi family of boards.

The supported and tested boards are:

- [OrangPi Zero](https://hub.mender.io/t/orangepi-zero/142/3)
- [OrangPi Pc Plus](https://hub.mender.io/t/orangepi-pc-plus/73/2)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

*NOTE*! Even though the integration has only been tested on OrangePi PC Plus
all the SUNXI boards share the same U-boot configuration
(where the integration work is) which means that it probably works on other
boards as well without any additional work.

## Dependencies

This layer depends on:

```
URI: https://github.com/linux-sunxi/meta-sunxi.git
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
mkdir mender-sunxi && cd mender-sunxi
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-sunxi/scripts/manifest-sunxi.xml \
           -b zeus
repo sync
source setup-environment sunxi
MACHINE=orange-pi-zeo bitbake core-image-base

```


## Maintainer

The authors and maintainers of this layer are:

- Mirza Krak - <mirza.krak@northern.tech> - [mirzak](https://github.com/mirzak)
- Marek Belisko - <marek.belisko@gmail.com> - [nandra](https://github.com/nandra)

Always include the maintainers when suggesting code changes to this layer. Mender integration for SUNXI boards
