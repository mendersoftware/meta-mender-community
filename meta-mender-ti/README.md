# meta-mender-ti

Mender integration layer for boards based on machines maintained in [meta-ti](https://git.yoctoproject.org/git/meta-ti).
Note that this layer currently only contains templates, as the tested targets require no modifications beyond the
generic Mender integation.

Supported targets:

- [BeaglePlay](https://beagleboard.org/play) (default)
- [BeagleBone AI-64](https://beagleboard.org/ai-64)

Addititional information can be found on the [Mender Hub](https://hub.mender.io):

- [BeaglePlay](https://hub.mender.io/t/beagleplay/5792)
- [BeagleBone AI-64](https://hub.mender.io/t/beaglebone-ai-64/5793)

## Dependencies

This layer depends on:

```
URI: https://git.yoctoproject.org/poky
branch: kirkstone
revision: HEAD

URI: https://git.yoctoproject.org/meta-arm
layers: meta-arm, meta-arm-toolchain
branch: kirkstone
revision: HEAD

URI: https://git.yoctoproject.org/meta-ti
layers: meta-ti-bsp
branch: kirkstone
revision: HEAD

URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: kirkstone
revision: HEAD
```

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir mender-ti && cd mender-ti
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-ti/scripts/manifest-ti.xml \
           -b kirkstone
repo sync
source setup-environment ti
bitbake core-image-base
```

Flash the resulting `tmp/deploy/images/beagleplay/core-image-base-xyz.sdimg` file to a SD card and boot up.