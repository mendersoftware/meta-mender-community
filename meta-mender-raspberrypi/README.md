# meta-mender-raspberrypi

Mender integration layer for Raspberry Pi family of boards. Note that this layer
only contains templates, and the actual integration patches live in
[meta-mender/meta-mender-raspberrypi](https://github.com/mendersoftware/meta-mender/tree/master/meta-mender-raspberrypi).

The officially supported and tested boards are:

| Board       | MACHINE     | Notes |
| ----------- | ----------- | ----- |
| [Raspberry Pi 3 Model B/B+](https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus) | `raspberrypi3` | [Mender Hub article](https://hub.mender.io/t/raspberry-pi-3-model-b-b/57) |
| [Raspberry Pi 4 Model B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b) | `raspberrypi4` | [Mender Hub article](https://hub.mender.io/t/raspberry-pi-4-model-b/889/2) |

The following boards are known to build and work, but are not undergoing QA:

| Board       | MACHINE     | Notes |
| ----------- | ----------- | ----- |
| [Raspberry Pi 0 Wifi](https://www.raspberrypi.com/products/raspberry-pi-zero-w) | `raspberrypi0-wifi` | [Mender Hub article](https://hub.mender.io/t/raspberry-pi-0-wifi/78) |
| [Raspberry Pi 0](https://www.raspberrypi.com/products/raspberry-pi-zero) | `raspberrypi0` | |
| [Raspberry Pi 0-2W](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w) | `raspberrypi0-2w` | |
| [Raspberry Pi 0-2W - 64bit](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w) | `raspberrypi0-2w-64` | same hardware as `raspberrypi0-2w`, but a 64bit Linux distribution |
| [Raspberry Pi](https://www.raspberrypi.com/products/raspberry-pi-1-model-b-plus) | `raspberrypi` | |
| [Raspberry Pi Compute Module 1](https://www.raspberrypi.com/products/compute-module-1) | `raspberrypi-cm` | |
| [Raspberry Pi 2](https://www.raspberrypi.com/products/raspberry-pi-2-model-b/) | `raspberrypi2` | |
| [Raspberry Pi Compute Module 3](https://www.raspberrypi.com/products/compute-module-3-plus) | `raspberrypi-cm3` | [Mender Hub article](https://hub.mender.io/t/raspberry-pi-compute-module-3/110/2) |
| [Raspberry Pi 3 Model B/B+ - 64bit](https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus) | `raspberrypi3-64` | same hardware as `raspberrypi3`, but a 64bit Linux distribution |
| [Raspberry Pi 4 Model B - 64bit](https://www.raspberrypi.com/products/raspberry-pi-4-model-b) | `raspberrypi4-64` | same hardware as `raspberrypi4`, but a 64bit Linux distribution |

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.


## Dependencies

This layer depends on:

```
URI: https://github.com/agherzan/meta-raspberrypi
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


```
mkdir mender-raspberrypi && cd mender-raspberrypi
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-raspberrypi/scripts/manifest-raspberrypi.xml \
           -b kirkstone
repo sync
source setup-environment raspberrypi
MACHINE=raspberrypi3 bitbake core-image-base
```


