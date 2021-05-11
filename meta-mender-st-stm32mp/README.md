# meta-mender-st-stm32mp

Mender integration layer for STM32MP family of boards.

The supported and tested boards are:

- [STM32MP157C Discovery Kit](https://hub.mender.io/t/stm32mp157c-discovery-kit/1676)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Dependencies

This layer depends on:

```
URI: https://github.com/STMicroelectronics/meta-st-stm32mp
branch: dunfell
revision: HEAD
```

```
URI: https://github.com/STMicroelectronics/meta-st-openstlinux
branch: dunfell
revision: HEAD
```

```
URI: https://github.com/STMicroelectronics/meta-st-stm32mp-addons
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
mkdir mender-stm32mp && cd mender-stm32mp
repo init -u https://github.com/STMicroelectronics/oe-manifest.git -b dunfell


wget --directory-prefix .repo/manifests https://raw.githubusercontent.com/mendersoftware/meta-mender-community/dunfell/meta-mender-st-stm32mp/scripts/stm32mp-mender.xml

repo init -m stm32mp-mender.xml
repo sync
. stm32mp-setup-mender.sh
bitbake st-image-core
```


## Maintainer

The authors and maintainers of this layer are:

- Mirza Krak - <mirza.krak@northern.tech> - [mirzak](https://github.com/mirzak)

Always include the maintainers when suggesting code changes to this layer.
