# Mender integration for SUNXI boards

Supported boards:

- OrangePi PC Plus

*NOTE*! Even though the integration has only been tested on OrangePi PC Plus
all the SUNXI boards share the same U-boot configuration
(where the integration work is) which means that it probably works on other
boards as well without any additional work.

## Build

Download the source:

    $ mkdir mender-sunxi
    $ cd mender-sunxi
    $ repo init \
           -u https://github.com/mendersoftware/meta-mender-community \
           -m meta-mender-sunxi/scripts/manifest-sunxi.xml \
           -b sumo

Setup environment

    $ . setup-environment sunxi

Build

    $ bitbake core-image-base
