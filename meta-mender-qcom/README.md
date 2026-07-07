# meta-mender-qcom

Mender integration for Qualcomm (qualcomm-linux `meta-qcom`) based boards.

Supported and tested boards:
 - **Arduino Uno Q** (Qualcomm Dragonwing QRB2210, MACHINE `uno-q`)

## Approach

Unlike Mender's classic dual-rootfs + U-Boot/GRUB integration, this layer reuses the
platform's **native A/B boot slots** (Qualcomm ABL + `qbootctl`) and drives them from a
custom Mender **Update Module** (`qbootctl-rootfs`). This avoids re-partitioning around
Mender's model and instead fits the Qualcomm boot flow (PBL → XBL → ABL → U-Boot → UEFI →
systemd-boot/UKI).

What the layer provides:
 - **Slotted OS layout** — a `qcom-partition-conf` bbappend derives a `system_a`/`system_b`
   (+ `userdata`, + `dtbo_a`/`dtbo_b` required by `qbootctl -s`) GPT from the stock
   `qrb2210-unoq` partition table (`QCOM_PARTITION_FILES_SUBDIR = partitions/qrb2210-unoq/system-ab`).
 - **Slot-aware initramfs** (`unoq-initramfs-ab` + the `86-abslot` initramfs-framework module) —
   reads the active slot via `qbootctl` and mounts `system_<slot>`. Self-heals: if the active
   slot has no valid filesystem it switches to the other slot (`qbootctl -s`/`-m`) and reboots,
   so a bad update rolls back deterministically.
 - **`qbootctl-rootfs` Mender Update Module** — writes the payload to the inactive slot,
   `qbootctl -s` it, reboots (Automatic), verifies the booted slot, commits with `qbootctl -m`,
   rolls back on failure.
 - **Persistent Mender state** — `userdata` is mounted at `/data` and `/var/lib/mender` is bound
   onto it so device identity + in-flight update state survive the rootfs swap.
 - **bless-boot gating** — a drop-in suppresses meta-qcom's automatic slot-bless while a Mender
   update is in flight, so Mender owns commit/rollback (normal boots still auto-bless).

## Dependencies

This layer depends on:

```
URI: https://github.com/qualcomm-linux/meta-qcom
branch: master
URI: https://github.com/qualcomm-linux/meta-qcom-3rdparty   # provides the uno-q MACHINE + firmware/kernel/u-boot
branch: main
URI: https://github.com/mendersoftware/meta-mender
branch: wrynose
```

## Quick start

Build configs (kas) live in the companion
[mender-community-images](https://github.com/theyoctojester/mender-community-images) repo:

```
kas build mender-community-images/yocto/wrynose/floating/uno-q.yml
```

## Flashing / console

The Uno Q is flashed over Qualcomm EDL with `qdl` (the build produces a `.qcomflash` set):

```
qdl --debug --storage emmc prog_firehose_ddr.elf rawprogram0.xml patch0.xml
```

Network/connectivity is **site-specific** and intentionally not shipped here (no baked
credentials); configure WiFi/networking at runtime or via a local overlay.

## Future work

The Update-Module approach extends naturally to the other updatable parts of the Uno Q as
separate Mender artifact types alongside the rootfs one:
 - the on-board **STM32U585 MCU** firmware (Zephyr), and
 - **AI models** shipped in conjunction with Edge Impulse.
