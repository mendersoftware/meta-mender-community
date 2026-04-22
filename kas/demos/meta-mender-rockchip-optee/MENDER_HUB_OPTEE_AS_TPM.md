# Using OP-TEE as a TPM for automatic LUKS unlock on Rockchip

In this post, we walk through a practical pattern for using OP-TEE + fTPM as a TPM2-backed unlock mechanism for a persistent encrypted partition on Rockchip boards.

The implementation shown here is based on:
- [meta-rockchip-optee](../../../../meta-rockchip-optee)
- [OPTEE_BOOTFLOW.md](./OPTEE_BOOTFLOW.md)

If you already use Mender and Yocto, this approach gives you hardware-backed secret handling for storage unlock, while keeping the flow fully automated on first boot.

---

## Why use OP-TEE as TPM in this setup?

On these Rockchip platforms, OP-TEE provides the secure world foundation, and `tpm_ftpm_tee` exposes a TPM2 interface to Linux (`/dev/tpm0`, `/dev/tpmrm0`). That lets us use standard Linux tooling:

- `cryptsetup` for LUKS2
- `systemd-cryptenroll` for TPM2 token enrollment
- `systemd-cryptsetup` for unlock at boot

So the system behaves like a TPM-backed Linux setup, but the TPM is delivered through OP-TEE/fTPM.

---

## High-level flow

This is the runtime sequence implemented in the layer:

1. Detect the partition labeled `encrypted`
2. Create a random key file (`/root/static-key`)
3. `luksFormat` the partition as LUKS2
4. Open as `static`, create ext4, close it
5. Enroll TPM2 token with `systemd-cryptenroll --tpm2-device=auto`
6. Securely remove the temporary key file
7. Write/update `/etc/crypttab` for TPM unlock
8. Write/update `/etc/fstab` for `/mnt/static`
9. Validate unlock by calling `systemd-cryptsetup attach ... tpm2-device=auto`
10. Reboot

For architecture and boot-stage context, see [OPTEE_BOOTFLOW.md](./OPTEE_BOOTFLOW.md).

---

## What in the layer makes this work

The key pieces in `meta-rockchip-optee` are:

- `recipes-tpm/firstboot-init/files/firstboot-init.sh`
- `recipes-tpm/firstboot-init/files/firstboot-init.service`
- `recipes-tpm/firstboot-init/files/load-ftpm-tee.service`
- `recipes-tpm/firstboot-init/files/check-ftpm.sh`

### Service ordering highlights

`load-ftpm-tee.service` is ordered before cryptsetup-related targets and loads `tpm_ftpm_tee`.

`firstboot-init.service` runs once and prepares encryption, enrollment, and mount config.

For older `systemd` variants that do not support some `crypttab` `x-systemd.*` options, the script adds a drop-in for `systemd-cryptsetup@static.service` to wait for `/dev/tpmrm0` before unlock attempts.

### Kernel config additions (Kconfig fragments)

The layer enables OP-TEE, fTPM, and dm-crypt with kernel config fragments in:

- `meta-rockchip-optee/recipes-kernel/linux/files/optee.cfg`
- `meta-rockchip-optee/recipes-kernel/linux/files/tpm-ftpm-tee.cfg`
- `meta-rockchip-optee/recipes-kernel/linux/files/dm-crypt.cfg`

The fragments are pulled in by:

- `meta-rockchip-optee/recipes-kernel/linux/linux-%.bbappend`

Key additions are:

- OP-TEE core:
	- `CONFIG_TEE=y`
	- `CONFIG_OPTEE=y`
	- `CONFIG_DMA_SHARED_BUFFER=y`

- TPM/fTPM over OP-TEE:
	- `CONFIG_TCG_TPM=y`
	- `CONFIG_TCG_FTPM_TEE=m`
	- `CONFIG_HW_RANDOM_TPM=m`

- LUKS/dm-crypt path:
	- `CONFIG_DM_CRYPT=y`
	- `CONFIG_BLK_DEV_DM=y`
	- `CONFIG_CRYPTO_AES=y`
	- `CONFIG_CRYPTO_XTS=y`
	- `CONFIG_CRYPTO_SHA256=y`
	- `CONFIG_CRYPTO_SHA512=y`

In addition, `linux-%.bbappend` appends OP-TEE and fTPM nodes into the Rockchip DTS to ensure the kernel can probe OP-TEE and expose the TPM path.

---

## Build and boot

Use the demo config:

```bash
kas build kas/demos/rock-4c-plus-enc.yml
```

Flash the resulting image as you normally do for your board.

On first boot, the one-shot init service performs encryption + enrollment, then reboots.

---

## Where the implementation lives

To keep this post focused, low-level command flow and boot-time handling are implemented in the layer scripts and recipe overrides.

Primary implementation entry point:
- `meta-rockchip-optee/recipes-tpm/firstboot-init/files/firstboot-init.sh`

Service wiring and integration details:
- `meta-rockchip-optee/recipes-tpm/firstboot-init/files/firstboot-init.service`
- `meta-rockchip-optee/recipes-tpm/firstboot-init/files/load-ftpm-tee.service`
- `meta-rockchip-optee/recipes-core/**/*.bbappend`
- `meta-rockchip-optee/recipes-kernel/**/*.bbappend`

If you are adapting this for your own product layer, move the platform-specific low-level behavior into your own `bbappend` files and keep the post-level documentation at architecture and workflow level.

---

## Troubleshooting notes

### `Timed out waiting for security device`

This usually means TPM is not ready when `systemd-cryptsetup@static` starts.

Useful checks:

```bash
journalctl -b -u load-ftpm-tee.service -u systemd-cryptsetup@static.service --no-pager
/usr/sbin/check-ftpm.sh
```

### `Encountered unknown /etc/crypttab option 'x-systemd....'`

Your `systemd` build is older and ignores those options. In this layer, the workaround is a unit drop-in for `systemd-cryptsetup@static.service` plus a wait loop for `/dev/tpmrm0`.

### Leftover empty `/root/static-key`

If you see an empty file after first boot, ensure secure cleanup uses:

```bash
shred -uvfz /root/static-key || rm -f /root/static-key
```

(`-u` is required to unlink after overwrite.)

---

## Security notes

- This setup intentionally avoids PCR binding in environments where firmware PCR measurements are not stable/usable.
- TPM still provides hardware-backed key storage/unlock gating.
- If your platform has reliable measured boot PCRs, you can tighten policy with explicit PCR selection during enrollment.

---

## Wrap-up

Using OP-TEE-backed fTPM with standard Linux crypt tooling is a practical way to protect persistent data on Rockchip devices in a Mender-managed fleet.

You keep familiar operational interfaces (`cryptsetup`, `systemd-cryptsetup`) while leveraging secure-world services under the hood.

If you want, I can also provide a follow-up post draft focused only on the boot race fix strategy (service ordering, drop-ins, and diagnostics) with log examples.
