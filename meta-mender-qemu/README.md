# meta-mender-qemu

Mender integration layer for QEMU virtual devices. Note that this layer
only contains templates, and the actual integration patches live in
[meta-mender/meta-mender-qemu](https://github.com/mendersoftware/meta-mender/tree/master/meta-mender-qemu).

Supported targets:

- qemux86-64 (default)
- vexpress-qemu
- vexpress-qemu-flash

Visit [QEMU, the FAST! processor emulator](https://hub.mender.io/t/qemu-the-fast-processor-emulator/420/2)
for more information on status of the integration and more
detailed instructions on how to build and use images together with Mender for
the mentioned boards.


## Dependencies

This layer depends on:

```
URI: https://git.yoctoproject.org/git/poky
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
mkdir mender-qemu && cd mender-qemu
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-qemu/scripts/manifest-qemu.xml \
           -b zeus
repo sync
source setup-environment qemu
bitbake core-image-base
```


## Maintainer

The authors and maintainers of this layer are:

- Mirza Krak - <mirza.krak@northern.tech> - [mirzak](https://github.com/mirzak)

Always include the maintainers when suggesting code changes to this layer.
