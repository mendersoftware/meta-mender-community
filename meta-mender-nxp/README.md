# meta-mender-nxp

Mender integration for NXP i.MX reference boards built on the community
[meta-freescale](https://github.com/Freescale/meta-freescale) layer.

## Supported machines

| MACHINE | Board | Boot media |
| --- | --- | --- |
| `imx93-11x11-lpddr4x-evk` | NXP i.MX 93 11x11 LPDDR4X EVK | microSD (USDHC2) |

The layer's defaults are keyed on the `mx9-generic-bsp` family override that
meta-freescale already provides, not on a list of machines, so another
i.MX 9 board inherits these defaults without touching this layer. Board
specifics, meaning the defconfig patch and the device tree name, exist only
for the machine above.

## Layer dependencies

* `meta-mender-core` from [meta-mender](https://github.com/mendersoftware/meta-mender)
* `meta-freescale`

No NXP downstream layers (`meta-imx`) are required. meta-freescale wrynose
is self-contained for i.MX93: `u-boot-imx` lf_v2025.04, `linux-imx` 6.18,
`imx-atf` 2.14, `imx-boot`, `firmware-imx`, `imx-m33-demos`,
`ethos-u-firmware`. `IMX_DEFAULT_BSP = "nxp"` is set in
`conf/machine/include/imx93-evk.inc`, so this is still NXP's BSP, just the
community packaging of it.

Ready-to-use kas configurations live in
[mender-community-images](https://github.com/theyoctojester/mender-community-images)
under `yocto/wrynose/{tagged,floating}/imx93-11x11-lpddr4x-evk.yml`.

## What the layer does

* Patches `u-boot-imx` with the Mender configuration the board needs: a
  larger, redundant environment in MMC and the bootcount framework.
  `MENDER_UBOOT_AUTO_CONFIGURE` is off; the defconfig delta is carried
  explicitly so what lands in U-Boot is reviewable.
* Refreshes two meta-mender U-Boot patches against NXP's downstream tree,
  which lags the U-Boot meta-mender is written against.
* Builds a `boot.scr` from a `boot.cmd` that calls `mender_setup` and boots
  the rootfs Mender selected.
* Supplies the i.MX 9 defaults: `mender-uboot` + `mender-image-sd` instead
  of meta-mender's GRUB/UEFI, `imx-boot` as the bootloader file, the
  partition alignment that clears it, `boot.scr` appended to
  `IMAGE_BOOT_FILES`, and the BootROM offset derived from meta-freescale's
  own `IMX_BOOT_SEEK`.

## Board notes

### imx93-11x11-lpddr4x-evk

Do not use `MACHINE = imx93evk`. That is NXP's *consolidated* machine in
`meta-imx-bsp`; it only `require`s `imx93-11x11-lpddr4x-evk.conf` and adds
FRDM/QSB/14x14 device trees on top.

Boot from the microSD card requires SW1301 pole 2 ON, all others OFF.
NXP's *Getting Started with the i.MX93 EVK* boot switch table gives SD card
boot (USDHC2) as SW1301-4..1 = `0,0,1,0`, eMMC as `0,0,0,0` and serial
download as `0,0,1,1`.

These are genuinely board policy and live in the image configuration:

```
MENDER_STORAGE_DEVICE = "/dev/mmcblk1"          # microSD; eMMC is mmcblk0
MENDER_BOOT_PART_SIZE_MB = "64"
MENDER_UBOOT_CONFIG_SYS_MMC_ENV_PART = "0"
```

The bootloader file, its offset, the partition alignment and the `boot.scr`
entry in `IMAGE_BOOT_FILES` all come from the layer.

Resulting disk layout: `imx-boot` at 32 KiB, the `uboot.env` region at
8 MiB (environment at `0x800000`, redundant copy at `0x1000000`), boot
vfat 64 MB at 24 MiB, rootfs A and B, then the data partition.

## Adding a board

For another i.MX 9 board, which is the family the layer covers:

1. Add a defconfig patch under
   `recipes-bsp/u-boot/u-boot-imx/<machine>/` enabling a redundant
   environment in MMC and the bootcount framework, and reference it from
   `SRC_URI:append:<machine>` in `u-boot-imx_%.bbappend`. Set
   `MENDER_UBOOT_AUTO_CONFIGURE:<machine> = "0"` alongside it. Leaving both
   out is also valid: the board then gets meta-mender's generated
   configuration instead.
2. If meta-freescale lists more than one device tree for the machine, set
   `MENDER_DTB_NAME_FORCE:<machine>` in `conf/layer.conf`.
3. Set `MENDER_STORAGE_DEVICE` in the image configuration.

Nothing else is needed. `files/boot.cmd` is board-independent, and
`u-boot-scr`'s `COMPATIBLE_MACHINE` and the matching `DEPENDS` in the
bbappend are keyed on the family rather than on machine names. A board
that genuinely needs a different boot script can put one in a
machine-named subdirectory of `recipes-bsp/u-boot-scr/files/`.

For another family, add its override to the family-defaults block in
`conf/layer.conf`, to `COMPATIBLE_MACHINE` and to the `DEPENDS` beside it.
The i.MX 8 families need nothing beyond that, since none of those defaults
is specific to i.MX 9, but they are deliberately not claimed here until
somebody has booted one. Note that i.MX 6 and 7 are a different
proposition: they default to the mainline BSP and therefore to
`u-boot-fslc` rather than `u-boot-imx`, and are 32-bit, so they need a
second bbappend and a `bootz` boot script.

## Gotchas

Numbers 1 to 3 carry over from the earlier FRDM-IMX93 integration. The
settings they call for are in place here, but the failure modes they
describe were seen on that board.

1. **BootROM offset is sector 64, not 32.** The i.MX 9 BootROM reads the
   AHAB container at 32 KiB. `IMX_BOOT_SEEK` and the wks `--align 32` are
   in KiB, but `MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET` is in
   512-byte sectors, so it must be **64**. Wrong value means the BootROM
   silently finds nothing and the board hangs with no serial output.

2. **`boot.scr` must be appended to `IMAGE_BOOT_FILES`.** The layer does
   this for the families it covers, so it should not bite either.
   meta-freescale defaults the variable to `"${KERNEL_IMAGETYPE} ${dtb-list}"`
   and without the append, U-Boot's `bootflow scan` never finds the Mender boot script,
   only the BSP fallback `bootcmd` runs, and A/B plus bootcount stay
   dormant. The board boots and looks healthy, which is what makes this
   one expensive to spot.

3. **NXP convention is `${fdtfile}`, not `${fdt_file}`.** NXP downstream
   U-Boot defines only the no-underscore variant. The underscore form
   makes `load` fail silently with `Failed to load '/boot/'`, `booti`
   then hands Linux the `sr_ir_v2_cmd`-modified controller DTB,
   `imx_ele_ocotp` probe fails, and ethernet sits in a deferred-probe
   loop. Confirm from the boot log that the kernel prints
   `Machine model: NXP i.MX93 11X11 EVK board`.

4. **`cert-to-efi-sig-list` is missing on a meta-imx-free build.**
   `imx93_11x11_evk_defconfig` sets `CONFIG_EFI_CAPSULE_AUTHENTICATE=y`
   and `scripts/Makefile.lib` then runs `cert-to-efi-sig-list` while
   building the DTB. That binary comes from `efitools-native`, which
   exists only in `meta-imx-sdk`, so `u-boot-imx:do_compile` fails.
   `no-efi-capsule-auth.cfg` turns the symbol off. This is a
   meta-freescale gap rather than a Mender concern and lives here only
   because this layer is the one every Mender build of the board already
   pulls in; the proper fix is an `efitools` recipe in meta-freescale.

5. **meta-mender's U-Boot patches target a newer U-Boot than
   meta-freescale pins.** oe-core wrynose ships u-boot **2026.01**;
   meta-freescale pins `u-boot-imx` to NXP's **lf_v2025.04**. Two
   consequences, both handled by patches in this layer:

   * `0002-Integration-of-Mender-boot-code-into-U-Boot.patch` fails hunk 2
     of `include/env_default.h`. NXP's tree still guards the default
     environment body with `CONFIG_USE_DEFAULT_ENV_FILE`; mainline
     renamed it to `CONFIG_ENV_USE_DEFAULT_ENV_TEXT_FILE`. The upstream
     patch is dropped with `SRC_URI:remove` and a context-refreshed copy
     substituted. Only that one context line differs.
   * `config_mender.h` requires `CONFIG_ENV_REDUNDANT`, the name upstream
     adopted after v2025.04. NXP's tree still calls it
     `CONFIG_SYS_REDUNDAND_ENVIRONMENT`, so `do_compile` fails with
     `#error CONFIG_ENV_REDUNDANT is required for Mender to work` even
     though redundant environment support is correctly enabled. Patch
     `0003` adds a hidden alias symbol rather than renaming, because the
     rest of the tree still uses the old name.

   Re-check both on every meta-mender bump, and drop `0003` once
   `u-boot-imx` rebases past the rename.

6. **meta-freescale lists every board variant's device tree in
   `KERNEL_DEVICETREE`.** meta-mender wants exactly one, warns, and picks
   the *last* entry, which here is `imx93-11x11-evk-8mic-reve.dtb`, an
   accessory overlay. `MENDER_DTB_NAME_FORCE` is set in `layer.conf` to
   name the board's own DT.

Also note that `boot.cmd` uses `console=${console}` with no
`,${baudrate}`. NXP's `${console}` is already `ttyLP0,115200 earlycon`, so
appending the baud rate again produces
`console=ttyLP0,115200 earlycon,115200` and the kernel complains about an
unknown parameter.
