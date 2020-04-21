# meta-mender-coral

Mender integration layer for Google Coral family of boards.

The supported and tested boards are:

- [Google Coral Dev Board](https://hub.mender.io/t/google-coral-dev-board/1711)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://github.com/mirza/meta-coral
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
mkdir mender-coral && cd mender-coral
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-coral/scripts/manifest-coral.xml \
           -b zeus
repo sync
. setup-environment coral
MACHINE=coral-dev bitbake core-image-base
```


## Maintainer

The authors and maintainers of this layer are:

- Mirza Krak - <mirza.krak@northern.tech> - [mirzak](https://github.com/mirzak)

Always include the maintainers when suggesting code changes to this layer.
