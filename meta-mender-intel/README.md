# meta-mender-intel

Mender integration layer for Intel® boards. Note that this layer
only contains templates, and the actual integration patches live in
[meta-mender](https://github.com/mendersoftware/meta-mender).

The supported and tested boards are:

- [MinnowBoard Turbot](https://hub.mender.io/t/minnowboard-turbot/59)
- [Giada VM23](https://hub.mender.io/t/giada-vm23/613)
- [Intel® NUC](https://hub.mender.io/t/intel-nuc/308)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

**NOTE** The integration for Intel based boards is generic and chances are very
high that this will work any modern Intel based board.

## Dependencies

This layer depends on:

```
URI: https://git.yoctoproject.org/git/meta-intel
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
mkdir mender-intel && cd mender-intel
repo init -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-intel/scripts/manifest-intel.xml \
           -b kirkstone
repo sync
source setup-environment intel
bitbake core-image-base
```


