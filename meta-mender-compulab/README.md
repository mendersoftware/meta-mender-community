# Mender integration for Compulab boards

Supported boards:

 - CL-SOM-iMX8 - NXP i.MX8 System-on-Module (https://www.compulab.com/products/computer-on-modules/cl-som-imx8-nxp-i-mx-8-system-on-module-computer/)

## Build

Download the source:

    $ mkdir mender-compulab
    $ cd mender-compulab
    $ repo init \
           -u git://source.codeaurora.org/external/imx/imx-manifest.git \
           -m imx-4.9.88-2.0.0_ga.xml \
           -b imx-linux-rocko
    $ mkdir .repo/local_manifests
    $ cd .repo/local_manifests/
    $ wget https://raw.githubusercontent.com/mendersoftware/meta-mender-community/rocko/meta-mender-compulab/scripts/manifest-compulab-local-manifest.xml
    $ wget https://raw.githubusercontent.com/mendersoftware/meta-mender-community/rocko/scripts/mender.xml
    $ cd -
    $ repo sync
    $ cd .repo/local_manifests/
    $ ln -sf ../../sources/meta-mender-community/meta-mender-compulab/scripts/manifest-compulab-local-manifest.xml .
    $ ln -sf ../../sources/meta-mender-community/scripts/mender.xml .
    $ cd -

Setup environment

    $ export MACHINE=cl-som-imx8
    $ source fsl-setup-release.sh -b build
    $ source ../sources/meta-compulab-bsp/tools/setup-compulab-env
    $ cat ../sources/meta-mender-community/meta-mender-compulab/templates/bblayers.conf.append >> conf/bblayers.conf
    $ cat ../sources/meta-mender-community/templates/local.conf.append >> conf/local.conf
    $ cat ../sources/meta-mender-community/meta-mender-compulab/templates/local.conf.append >> conf/local.conf

Build

    $ bitbake core-image-full-cmdline
