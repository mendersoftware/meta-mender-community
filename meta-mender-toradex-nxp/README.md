# meta-mender-toradex-nxp

Mender integration layer for Toradex family of boards.

The supported and tested boards are:
- [Toradex Verdin iMX8M Mini](https://hub.mender.io/t/toradex-verdin-imx8m-mini/2908)
- [Toradex Verdin iMX8M Plus](https://hub.mender.io/t/toradex-verdin-imx8m-plus/5026)
- [Toradex Apalis iMX6](https://hub.mender.io/t/toradex-nxp-i-mx-6-computer-on-module-apalis-imx6/2331)
- [Toradex Apalis iMX8](https://hub.mender.io/t/toradex-apalis-i-mx8/4103)
- [Toradex Colibri iMX6ULL](https://hub.mender.io/t/toradex-colibri-i-mx6ull/4102)
- [Toradex Colibri iMX8X](https://hub.mender.io/t/toradex-colibri-i-mx6ull/4102)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://git.toradex.com/meta-toradex-nxp.git
branch: kirkstone-6.x.y
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
mkdir mender-toradex && cd mender-toradex
repo init -u https://git.toradex.com/toradex-manifest.git \
    -b refs/tags/6.0.0 \
    -m tdxref/default.xml

wget --directory-prefix .repo/local_manifests \
    https://raw.githubusercontent.com/mendersoftware/meta-mender-community/kirkstone-next/scripts/mender-no-setup.xml

repo sync

. export

echo "BBLAYERS += \" \${TOPDIR}/../layers/meta-mender/meta-mender-core \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${TOPDIR}/../layers/meta-mender-community/meta-mender-toradex-nxp \"" >> conf/bblayers.conf

# Omit this, if you intend to use this build in production
echo "BBLAYERS += \" \${TOPDIR}/../layers/meta-mender/meta-mender-demo \"" >> conf/bblayers.conf

cat ../layers/meta-mender-community/templates/local.conf.append >> conf/local.conf
cat ../layers/meta-mender-community/meta-mender-toradex-nxp/templates/local.conf.append >> conf/local.conf

MACHINE=blah bitbake tdx-reference-minimal-image
```

## Notes for colibri-imx6ull
- Current mender integration uses ubi volumes to store the redundant environment, this is why the regular u-boot-env partition has been removed from the MTDPARTS


