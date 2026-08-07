# meta-mender-toradex-nxp

Mender integration layer for Toradex family of boards.

So far the iamges build for:

- Toradex Verdin iMX8M Mini
- Toradex Verdin iMX8M Plus
- Toradex Colibri iMX8X

## Dependencies

This layer depends on:

```
URI: https://git.toradex.com/meta-toradex-nxp.git
branch: scarthgap-7.x.y
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: scarthgap
revision: HEAD
```

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir mender-toradex && cd mender-toradex

# Select the appropriate Toradex BSP version:
export TORADEX_BSP_VERSION=7.1.0

repo init -u https://git.toradex.com/toradex-manifest.git \
    -b refs/tags/${TORADEX_BSP_VERSION} \
    -m tdxref/default.xml

wget --directory-prefix .repo/local_manifests \
    https://raw.githubusercontent.com/mendersoftware/meta-mender-community/kirkstone/scripts/mender-no-setup-layers.xml

repo sync

. ./export

echo "BBLAYERS += \" \${TOPDIR}/../layers/meta-mender/meta-mender-core \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${TOPDIR}/../layers/meta-mender-community/meta-mender-toradex-nxp \"" >> conf/bblayers.conf

# Omit this, if you intend to use this build in production
echo "BBLAYERS += \" \${TOPDIR}/../layers/meta-mender/meta-mender-demo \"" >> conf/bblayers.conf

cat ../layers/meta-mender-community/templates/local.conf.append >> conf/local.conf
cat ../layers/meta-mender-community/meta-mender-toradex-nxp/templates/local.conf.append >> conf/local.conf

echo "TORADEX_BSP_VERSION = \"toradex-bsp-${TORADEX_BSP_VERSION}\"" >> conf/local.conf

You need to accept the Freescale EULA at ‘…/sources/meta-freescale/EULA’. Please read it and in case you accept it, run:
echo "ACCEPT_FSL_EULA = \"1\"" >> conf/local.conf 

MACHINE=blah bitbake tdx-reference-minimal-image
```