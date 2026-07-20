# meta-mender-xilinx

Mender integration for Xilinx / AMD Zynq based boards.

The supported and tested boards are:

 - [Digilent Arty Z7-20](https://digilent.com/reference/programmable-logic/arty-z7/start) (Zynq-7000 xc7z020)

Visit the individual board links above for more information on status of the
integration and more detailed instructions on how to build and use images
together with Mender for the mentioned boards.

## Layer structure

Board bring-up (machine, devicetree, U-Boot control DTS, platform-init) lives
in the nested BSP sub-layer [`meta-arty-z7`](meta-arty-z7/README.md), kept
separate from the Mender integration so a plain bring-up build stays free of
Mender patches. Both layers are added together by the kas configuration.

This layer itself carries:

- `recipes-bsp/u-boot` — Mender integration for the `u-boot-xlnx` fork
  (meta-mender only appends to the plain `u-boot` recipe): `PROVIDES "u-boot"`,
  a rebased boot-code patch, and a Zynq `env_get_location` MMC fix required for
  Mender's redundant raw-MMC environment on SD boot.
- `recipes-mender/fpga-bitstream-module` — a Mender Update Module that deploys
  Zynq PL bitstreams to `/data/fpga` and programs them via the kernel FPGA
  manager, with a boot-time reload service. It survives rootfs A/B updates and
  needs no reboot.

## Dependencies

This layer depends on:

```
URI: https://github.com/Xilinx/meta-xilinx
layers: meta-xilinx-core
branch: scarthgap
revision: HEAD
```

```
URI: https://git.yoctoproject.org/meta-arm
layers: meta-arm, meta-arm-toolchain
branch: scarthgap
revision: HEAD
```

```
URI: https://github.com/mendersoftware/meta-mender.git
layers: meta-mender-core
branch: scarthgap
revision: HEAD
```

It also depends on the nested `meta-arty-z7` BSP sub-layer in this repository.

## Quick start

The following commands will setup the environment and allow you to build images
that have Mender integrated.

```
mkdir -p meta-mender-community/mender-xilinx && cd meta-mender-community/mender-xilinx
kas build ../kas/arty-z7-20.yml
```

The Vivado-free bitstream build flow used to produce the demo `fpga-bitstream`
artifacts is documented in the Arty Z7-20 Mender Hub tutorials.
