# meta-mender-variscite

Mender integration layer for Variscite family of boards.

Variscite SoM's are configurable when you order them, this means that the
integration can be configuration specific and you might need to make
adjustments based on your configuration.

The goal of this layer is to support as many configurations as possible,
ultimately all of them, but to be able to do that we need to collaborate.

The supported and tested boards are:

- [DART-6UL (uSD/eMMC, WiFi)](https://hub.mender.io/t/variscite-dart-6ul/483)
- [NXP i.MX 8M Mini (uSD/eMMC, WiFi)](https://hub.mender.io/t/variscite-var-som-mx8m-mini-nxp-i-mx-8m-mini/1918)
- [NXP i.MX8 NANO (uSD/eMMC, WiFi)](https://hub.mender.io/t/variscite-var-som-mx8m-nano-nxp-i-mx-8m-nano/1928)

## Dependencies

This layer depends on:

```
URI: https://github.com/varigit/meta-variscite-imx
branch: zeus-fsl-5.4.3-mx6ul-v1.0
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
mkdir mender-variscite && cd mender-variscite
repo init -u https://github.com/varigit/variscite-bsp-platform.git \
    -b refs/tags/zeus-fsl-5.4.3-mx6ul-v1.0 -m imx-5.4.3-1.0.1-var01.xml
mkdir .repo/local_manifests
cd .repo/local_manifests/
wget https://raw.githubusercontent.com/mendersoftware/meta-mender-community/zeus/scripts/mender-no-setup.xml
cd -
repo sync
cd .repo/local_manifests/
ln -sf ../../sources/meta-mender-community/scripts/mender-no-setup.xml .
cd -
MACHINE=imx6ul-var-dart DISTRO=fsl-imx-xwayland . var-setup-release.sh -b build
cat ../sources/meta-mender-community/meta-mender-variscite/templates/bblayers.conf.append >> conf/bblayers.conf
cat ../sources/meta-mender-community/templates/local.conf.append >> conf/local.conf
cat ../sources/meta-mender-community/meta-mender-variscite/templates/local.conf.append >> conf/local.conf
cat ../sources/meta-mender-community/meta-mender-variscite/templates/local-emmc.conf.append >> conf/local.conf
bitbake core-image-base
```


## Maintainer

The authors and maintainers of this layer are:

- Drew Moseley - <drew.moseley@northern.tech> - [drewmoseley](https://github.com/drewmoseley)

Always include the maintainers when suggesting code changes to this layer.
