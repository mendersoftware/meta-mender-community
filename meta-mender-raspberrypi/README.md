# meta-mender-raspberrypi

Mender integration layer for Raspberry Pi family of boards. Note that this layer
only contains templates, and the actual integration patches live in
[meta-mender/meta-mender-raspberrypi](https://github.com/mendersoftware/meta-mender/tree/master/meta-mender-raspberrypi).

The supported and tested boards are:

- [Raspberry Pi 4 Model B](https://hub.mender.io/t/raspberry-pi-4-model-b/889/2)
- [Raspberry Pi 3 Model B/B+](https://hub.mender.io/t/raspberry-pi-3-model-b-b/57)
- [Raspberry Pi CM3](https://hub.mender.io/t/raspberry-pi-compute-module-3/110/2)
- [Raspberry Pi 0 Wifi](https://hub.mender.io/t/raspberry-pi-0-wifi/78)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.


## Dependencies

This layer depends on:

```
URI: https://github.com/agherzan/meta-raspberrypi
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
mkdir mender-raspberrypi && cd mender-raspberrypi
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-raspberrypi/scripts/manifest-raspberrypi.xml \
           -b zeus
repo sync
source setup-environment raspberrypi
MACHINE=raspberrypi3 bitbake core-image-base
```


## Maintainer

The authors and maintainers of this layer are:

- Mirza Krak - <mirza.krak@northern.tech> - [mirzak](https://github.com/mirzak)
- Drew Moseley - <drew.moseley@northern.tech> - [drewmoseley](https://github.com/drewmoseley)

Always include the maintainers when suggesting code changes to this layer.
