# imx93-frdm-whinlatter — Mender integration porting notes

One-off port of the scarthgap-era Mender integration for the NXP FRDM-IMX93
onto NXP's whinlatter BSP (Yocto 5.3, kernel 6.18.2, u-boot 2025.04, MACHINE
`imx93-11x11-lpddr4x-frdm`). **Not upstreamable** — pins NXP-downstream SHAs,
vendors small fixes, tailored to one board on one test rig. Exists so the
next release has a known-good Mender build to forward-port from.

Last validated end-to-end 2026-04-26 (bootloader-validation suite + Hosted
Mender remote terminal + DHCP/network on arrakeen).

## Base pins

| Component                   | Pin                                                       | Source                              |
| ---                         | ---                                                       | ---                                 |
| meta-mender                 | `58f13d0a` master "Sync with master" (2026-04-01)         | upstream master at branch point     |
| meta-mender-community       | `scarthgap` (no whinlatter branch upstream)               | upstream                            |
| poky / oe-core / bitbake    | whinlatter SHAs                                           | NXP imx-6.18.2-1.0.0 manifest       |
| meta-openembedded, meta-arm | whinlatter SHAs                                           | NXP imx-6.18.2-1.0.0 manifest       |
| meta-freescale {-3rdparty,-distro} | whinlatter SHAs                                    | NXP imx-6.18.2-1.0.0 manifest       |
| meta-imx                    | tag `rel_imx_6.18.2_1.0.0`                                | NXP                                 |

Exact SHAs live in `imx93-frdm-whinlatter.yml` next to this file. NXP manifest
is at https://github.com/nxp-imx/imx-manifest/tree/imx-linux-whinlatter.

### meta-mender carried patches

The kas file pins meta-mender at
`http://192.168.1.14/theyoctojester/meta-mender.git`, branch
`imx93-frdm-whinlatter`, commit `8c762a5d26824a16b1245027cd283639f6613816`,
also tagged `integration/imx93-frdm-whinlatter/2026-04-26` in both that
mirror and (separately) in this repo on
`github.com/mendersoftware/meta-mender-community`. Two commits on top of
upstream master `58f13d0a`:

- **`9d08d342`** — refresh `0002-Integration-of-Mender-boot-code-into-U-Boot.patch`
  hunk against u-boot 2025.04's `$(if $(CONFIG_SYS_CONFIG_NAME)…)` form.
  Without it, the patch applies with fuzz or fails outright.
- **`8c762a5d`** — cherry-pick of upstream `249292bc`. Adds
  `destsuffix=${GO_SRCURI_DESTSUFFIX}` to mender-connect / mender-snapshot Go
  SRC_URIs so sources land at the GOPATH path the recipes expect on whinlatter.
  Drop when meta-mender base ≥ `249292bc`.

## Gotchas (look here first when something breaks)

1. **BootROM offset is sector 64, not 32.** i.MX 9 BootROM reads the AHAB
   container at 32 KiB on SD/eMMC. `IMX_BOOT_SEEK` (meta-imx-bsp) is in KiB,
   wks `--align 32` is in KiB, but `MENDER_IMAGE_BOOTLOADER_BOOTSECTOR_OFFSET`
   is in 512-byte sectors → set to **64**, not 32. Wrong value → BootROM
   silently doesn't find the container, board hangs with no serial output.

2. **boot.scr must be appended to `IMAGE_BOOT_FILES`.** meta-freescale
   defaults this to `"${KERNEL_IMAGETYPE} ${dtb-list}"`. Without the append,
   distro_bootcmd / bootflow scan never finds the Mender boot script — only
   the BSP fallback bootcmd runs, A/B and bootcount stay dormant.

3. **NXP convention is `${fdtfile}`, not `${fdt_file}`.** The board-specific
   `boot.cmd` (`meta-mender-nxp/recipes-bsp/u-boot-scr/files/imx93-11x11-lpddr4x-frdm/boot.cmd`)
   uses `${fdtfile}`. NXP downstream u-boot defines only the no-underscore
   variant; the underscore variant is empty, fatload silently fails with
   `Failed to load '/boot/'`, booti then hands Linux the embedded
   `sr_ir_v2_cmd`-modified controller DTB, `imx_ele_ocotp` probe fails,
   ethernet stays in deferred-probe loop. The other boards in
   meta-mender-nxp (`imx93-voipac`, `olimex-imx8mp-evb`) still use
   `${fdt_file}` — likely broken in the same way, not investigated.

4. **u-boot defconfig pulls efitools.** `CONFIG_EFI_CAPSULE_AUTHENTICATE=y`
   in NXP's `imx93_11x11_frdm_defconfig` invokes `cert-to-efi-sig-list` at
   do_compile time. Current workaround: include `meta-imx-sdk` (which drags
   `meta-perl` for `fsl-sdk-release` parsing). **Cleaner alternative not
   done**: extend the defconfig patch with `# CONFIG_EFI_CAPSULE_AUTHENTICATE
   is not set` and drop both layers. Worth doing on the next bump.

5. **mender-connect 3.0.0 ships no `LIC_FILES_CHKSUM.sha256`.**
   `_MENDER_DISABLE_STRICT_LICENSE_CHECKING = "1"` flips the
   `mender-licensing.bbclass` escape hatch. Verify on each meta-mender bump
   whether the upstream tree has grown the file and the workaround can go.

6. **`kas build` flakes under sustained load** — bitbake server loses ping
   and the kas supervisor times out at 60s. Use `kas shell -c 'bitbake …'`
   instead.

## Building

```
cd meta-mender-community
mkdir my-imx93-frdm-whinlatter && cd $_
ln -s ~/kas/tyj-local.yml ~/kas/tyj-mender.yml ~/kas/tyj-debug.yml .
kas shell -c 'bitbake core-image-minimal' \
    ../kas/imx93-frdm-whinlatter.yml:tyj-local.yml:tyj-mender.yml:tyj-debug.yml
```

Artifacts in `build/tmp/deploy/images/imx93-11x11-lpddr4x-frdm/`:

- `core-image-minimal-*.sdimg` (4 GB) — **flash this**. The full
  Mender disk image with all four partitions (boot vfat, rootfsA,
  rootfsB, data). Compress with `zstd` for transfer.
- `core-image-minimal-*.wic.zst` — NXP-side wic with only boot +
  rootfsA. **Do not flash this for Mender** — `mender-grow-data`
  will fail because the data partition is missing. (Empirically
  hit this on 2026-04-26.)
- `core-image-minimal-*.mender` — Mender Artifact for OTA
  deployment via Hosted Mender, after the device has registered.

Flash via the standard rig procedure (compress sdimg with zstd → scp
→ curl power off → `usbsdmux host` → ssh `zstd -d -c | sudo dd
of=/dev/sdb` → `usbsdmux dut` → curl power on).

## Forward-port checklist (next BSP bump)

When NXP releases the next manifest (e.g. `imx-7.x.x_1.0.0`):

1. Bump every `commit:` in `imx93-frdm-whinlatter.yml` to the SHAs from the
   new manifest. The NXP manifest is the authoritative source.
2. Re-derive the u-boot defconfig patch against the new u-boot's
   `imx93_11x11_frdm_defconfig`. Keep the same logical changes (env size,
   redundant env, bootcount). Check whether `CONFIG_EFI_CAPSULE_AUTHENTICATE`
   is still on — if so, this is your chance to disable it in the patch and
   drop `meta-imx-sdk` + `meta-perl` (gotcha #4).
3. Bump `meta-mender` base from `58f13d0a` to current master. Recheck the
   two carried patches: `8c762a5d` (Wrynose Go destsuffix) is likely already
   in master; `9d08d342` (Makefile.autoconf hunk) probably needs another
   refresh, not dropping.
4. Boot to Linux on the rig. Compare console output against the saved
   evidence logs (`../../imx93-frdm/logs/acm0-mender-whinlatter-*.log`) to
   confirm none of the gotchas have silently re-broken.
5. Re-enable bootloader-validation in the kas file
   (`IMAGE_INSTALL:append = " bootloader-validation"` and
   `MENDER_FEATURES_ENABLE:append = " mender-prepopulate-inactive-partition"`
   — currently removed) and confirm the suite still passes.
6. Register with Hosted Mender (tenant `626a6e59bb8795f14e4f3337`), build a
   v2 artifact with a bumped `MENDER_ARTIFACT_NAME`, and verify a clean A→B
   switch + commit.

## Test rig

arrakeen 192.168.1.16 — usbsdmux `/dev/sg1`, host SD `/dev/sdb`, console
`/dev/ttyACM0` @ 115200 8N1, Shelly Gen2 RPC at 192.168.1.71.
Mender backend: https://hosted.mender.io, tenant `626a6e59bb8795f14e4f3337`.
