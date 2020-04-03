# meta-mender-odroid

Mender integration layer for Odroid family of boards.

The supported and tested boards are:

- [Hardkernel ODROID-C2](https://hub.mender.io/t/hardkernel-odroid-c2/478)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://github.com/akuster/meta-odroid
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
mkdir mender-odroid && cd mender-odroid
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-odroid/scripts/manifest-odroid.xml \
           -b zeus
repo sync
source setup-environment odroid
MACHINE=odroid-c2 bitbake core-image-base
```


## Maintainer

The authors and maintainers of this layer are:

- Mirza Krak - <mirza.krak@northern.tech> - [mirzak](https://github.com/mirzak)

Always include the maintainers when suggesting code changes to this layer.
