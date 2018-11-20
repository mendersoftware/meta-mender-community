# Mender integration for Compulab boards

Supported boards:

 - CL-SOM-iMX6 - NXP i.MX6 System-on-Module (https://www.compulab.com/products/computer-on-modules/cl-som-imx6-nxp-freescale-i-mx-6-system-on-module/)

## Build

Download the source:

    $ mkdir mender-compulab
    $ cd mender-compulab
    $ repo init \
           -u git://git.freescale.com/imx/fsl-arm-yocto-bsp.git \
           -m imx-4.1.33-7ulp_beta.xml \
           -b imx-morty
    $ mkdir .repo/local_manifests
    $ cd .repo/local_manifests/
    $ wget https://raw.githubusercontent.com/mendersoftware/meta-mender-community/morty/meta-mender-compulab/scripts/manifest-compulab-local-manifest.xml
    $ wget https://raw.githubusercontent.com/mendersoftware/meta-mender-community/morty/scripts/mender-local-manifest.xml
    $ cd -
    $ repo sync
    $ cd .repo/local_manifests/
    $ ln -sf ../../sources/meta-mender-community/meta-mender-compulab/scripts/manifest-compulab-local-manifest.xml .
    $ ln -sf ../../sources/meta-mender-community/scripts/mender-local-manifest.xml .
    $ cd -

Setup environment

    $ source fsl-setup-release.sh -b build
    $ source ../sources/meta-compulab/bb-tools/setup-compulab-env
    $ cat ../sources/meta-mender-community/meta-mender-compulab/templates/bblayers.conf.append >> conf/bblayers.conf
    $ cat ../sources/meta-mender-community/templates/local.conf.append >> conf/local.conf
    $ cat ../sources/meta-mender-community/meta-mender-compulab/templates/local.conf.append >> conf/local.conf

Build

    $ bitbake core-image-full-cmdline
