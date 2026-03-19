# Enable OP-TEE and TPM fTPM TEE driver
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://optee.cfg file://tpm-ftpm-tee.cfg file://dm-crypt.cfg"

# Append the firmware/optee DT node to the board DTS so the kernel OP-TEE driver
# probes and creates /dev/tee0 + /dev/teepriv0.
# Also add the fTPM node so tpm_ftpm_tee driver probes and creates /dev/tpm0.
# Done via do_configure:append rather than a patch to avoid line-number drift
# between linux-yocto kernel versions.
do_configure:append:rock-4c-plus() {
    DTS="${S}/arch/arm64/boot/dts/rockchip/rk3399-rock-4c-plus.dts"
    # Only add the node if it is not already present (idempotent)
    if ! grep -q 'linaro,optee-tz' "${DTS}"; then
        cat >> "${DTS}" <<'OPTEE_NODE'

/* OP-TEE Trusted OS firmware node.
 * Required for the kernel TEE driver (drivers/tee/optee) to probe
 * and create /dev/tee0 + /dev/teepriv0.
 * OP-TEE is loaded as BL32 by SPL from the FIT image.
 */
/ {
	firmware {
		optee: optee {
			compatible = "linaro,optee-tz";
			method = "smc";
		};
		
		tpm {
			compatible = "microsoft,ftpm";
		};
	};
};
OPTEE_NODE
    fi
}
