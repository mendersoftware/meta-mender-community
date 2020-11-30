# meta-mender-toradex-nxp

Mender integration layer for Toradex family of boards.

The supported and tested boards are:

- [Toradex Verdin iMX8M Mini](https://hub.mender.io/t/toradex-verdin-imx8m-mini/2908)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://git.toradex.com/meta-toradex-nxp.git
branch: dunfell
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: dunfell
revision: HEAD
```

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.


```
mkdir mender-toradex && cd mender-toradex
repo init -u https://git.toradex.com/toradex-manifest.git \
    -b refs/tags/5.0.0 \
    -m tdxref/default.xml

wget --directory-prefix .repo/local_manifests \
    https://raw.githubusercontent.com/mendersoftware/meta-mender-community/dunfell/scripts/mender-no-setup.xml

repo sync

. export

echo "BBLAYERS += \" \${TOPDIR}/../layers/meta-mender/meta-mender-core \"" >> conf/bblayers.conf
echo "BBLAYERS += \" \${TOPDIR}/../layers/meta-mender-community/meta-mender-toradex-nxp \"" >> conf/bblayers.conf

# Omit this, if you intend to use this build in production
echo "BBLAYERS += \" \${TOPDIR}/../layers/meta-mender/meta-mender-demo \"" >> conf/bblayers.conf

cat ../layers/meta-mender-community/templates/local.conf.append >> conf/local.conf
cat ../layers/meta-mender-community/meta-mender-toradex-nxp/templates/local.conf.append >> conf/local.conf

MACHINE=verdin-imx8mm bitbake tdx-reference-minimal-image
```


## Maintainer

The authors and maintainers of this layer are:

- Mirza Krak - <mirza.krak@northern.tech> - [mirzak](https://github.com/mirzak)

Always include the maintainers when suggesting code changes to this layer.
