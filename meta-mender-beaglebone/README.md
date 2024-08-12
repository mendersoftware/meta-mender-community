# meta-mender-beaglebone

Mender integration for Beaglebone boards

The supported and tested boards are:

 - [BeagleBone Black](https://hub.mender.io/t/beaglebone-black/83)


Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://git.yoctoproject.org/git/poky
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

See the top level [README](../README.md) for instructions to build using the `kas` tool. Supported configurations are

- [`beaglebone.yml`](../kas/beaglebone.yml)
- [`beaglebone-uboot.yml`](../kas/beaglebone-uboot.yml)