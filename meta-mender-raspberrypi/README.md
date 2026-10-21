# meta-mender-raspberrypi

Mender integration for the Raspberry Pi boards supported by meta-raspberrypi:
U-Boot based A/B rootfs updates on a shared FAT boot partition, and an optional
updater for the boot partition itself.

## Dependencies

- meta-raspberrypi (branch wrynose)
- meta-mender (branch wrynose)

## Firmware updates

Boot-partition updates are opt-in through `INHERIT += "rpi-update-firmware"`.
The image recipe stages `IMAGE_BOOT_FILES` under `/boot/firmware`, using the
destination names from the initial boot image. The Artifact state script copies
that directory into the boot partition mount point
(`MENDER_BOOT_PART_MOUNT_LOCATION`, `/uboot` by default). It does not scan other
rootfs `/boot` files or delete existing boot files outside the selected
destinations.

Supported mappings are regular files, deploy-local file symlinks, source globs,
`source;destination` renames and destinations ending in `/`. An implicit
destination or `./` uses the source basename. Missing inputs, unmatched globs,
conflicting contents and unsupported paths fail the build. Directory inputs,
symlinks outside the deploy directory, absolute or `..` destinations and entries
with more than one `;` are not supported. Paths use ASCII letters, digits, `_`,
`.`, `+`, `-` and `/`; source patterns additionally allow shell glob syntax.

### Kernel on the shared FAT

Independently of the updater, for standard Mender U-Boot rootfs updates the
shared FAT does not need a second copy of the kernel: Mender's U-Boot boot code
loads it from `/boot` of the selected rootfs. The layer removes
`${KERNEL_IMAGETYPE}` from `RPI_EXTRA_IMAGE_BOOT_FILES` when `rpi`,
`mender-uboot`, `mender-update-install` and `RPI_USE_U_BOOT = "1"` apply. Rootfs
kernel installation and the U-Boot binary renamed to `${SDIMG_KERNELIMAGE}` are
unchanged. Custom boot scripts that need the FAT kernel can disable this removal
with `RPI_MENDER_EXTRA_IMAGE_BOOT_FILES_REMOVE = ""` in machine or distro
configuration. This only disables this layer's removal; exclusions from other
classes or settings remain active.

### Settings

| Variable | Read by | Default | Purpose |
| --- | --- | --- | --- |
| `RPI_FIRMWARE_EXCLUDE` | `rpi-update-firmware` class (image) | empty | Space-separated exact destination paths omitted after mapping expansion |
| `RPI_FIRMWARE_REQUIRED_FILES` | `update-firmware-state-script` recipe | `config.txt cmdline.txt ${SDIMG_KERNELIMAGE}`, plus `boot.scr` with U-Boot | Space-separated relative paths that must exist in the staged directory before copying |
| `RPI_FIRMWARE_SPACE_RESERVE_KIB` | `update-firmware-state-script` recipe | `1024` | Extra free-space reserve beyond pending copies and directory growth; `0` or a decimal integer without leading zeros |

Values read by the state-script recipe must be set in machine or distro
configuration (or the recipe); an image recipe cannot change them.
`RPI_FIRMWARE_EXCLUDE` may also be set in the image recipe.

The default 1024 KiB reserve is additional headroom beyond the calculated copy
requirements. Set it to `0` to disable the additional reserve; the calculated
capacity check remains active.

`SDIMG_KERNELIMAGE` must be nonempty when the default required-file list is
used; otherwise the state-script recipe is skipped with a reason. Custom boot
layouts can override the list, including setting it to an empty string to
disable these checks.

### Build dependencies

The class adds `do_rootfs[depends]` on the standard boot-file producers and
`do_image_mender[depends]` on the state script. Custom boot-file producers must
add their deploy tasks to the image's `do_rootfs[depends]`. Layers adding other
Artifact state scripts must ensure their deploy tasks precede `do_image_mender`,
including when that task is invoked directly.

### Running on the old OS

The state script runs on the **old OS**, before reboot. Before distributing an
Artifact, verify that the update source has `findmnt`, `mount`, `umount`,
coreutils `stat -f`, `sync` with a file argument and `sync -f`, `cmp` and `find`
with `-type` and `-print`. BusyBox does not provide `findmnt`; on such
a system the script fails before touching the boot partition. The recipe's
runtime dependencies only ensure these tools in newly built images; they do not
retrofit an installed OS.

### Migration from the previous class

- The state script is delivered inside the Artifact, so the first update
  from an image built with the previous class already runs the new script,
  on the old OS. Verify that the running OS provides the tools listed above.
  The shared boot files can be replaced on that first update; keep them
  compatible with both rootfs slots, because a rootfs rollback does not
  restore them.
- Versioned `Image-*` and `*.dtb` copies left in the FAT root by the previous
  script, and `*.tmp` files left by an interrupted run of it, are neither deleted
  nor counted. If the boot partition is too full,
  the space check fails before copying; remove those files by hand.
- Custom state scripts that read `/boot` of the inactive rootfs must switch to
  `/boot/firmware`.

### Limits

Existing files with identical contents are skipped. The space check
conservatively reserves all pending copies without crediting replaced files.
`cmdline.txt` and `config.txt` are copied after other files. Each copy uses a
temporary file and sync/rename. An interrupted copy can leave a
`.mender-firmware.*` temporary file next to the destination; it is not selected
by later updates and can be removed by hand. The boot partition update is
still not an atomic transaction: an
interrupted update can leave mixed generations, and a rootfs rollback does not
restore the shared boot partition. A failed `umount` of the source rootfs leaves
it mounted until reboot; later attempts fail until then.

### Host tests

```sh
python3 meta-mender-raspberrypi/tests/test_firmware.py
```

These tests simulate mounts, device checks and space queries. They do not
replace BitBake builds, FAT checks or device OTA and recovery testing.
