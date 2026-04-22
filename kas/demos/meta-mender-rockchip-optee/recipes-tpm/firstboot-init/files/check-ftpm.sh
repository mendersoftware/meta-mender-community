#!/bin/sh

echo "=== Checking OP-TEE fTPM Setup ==="

echo ""
echo "1. Checking if tee-supplicant is running:"
ps | grep tee-supplicant | grep -v grep || echo "   ERROR: tee-supplicant is NOT running"

echo ""
echo "2. Checking if fTPM TA is installed:"
if [ -f "/lib/optee_armtz/bc50d971-d4c9-42c4-82cb-343fb7f37896.ta" ]; then
    echo "   OK: fTPM TA found at /lib/optee_armtz/"
    ls -lh /lib/optee_armtz/bc50d971-*
else
    echo "   ERROR: fTPM TA NOT found"
fi

echo ""
echo "3. Checking kernel module:"
lsmod | grep tpm_ftpm_tee
if [ $? -eq 0 ]; then
    echo "   OK: tpm_ftpm_tee module is loaded"
else
    echo "   ERROR: tpm_ftpm_tee module is NOT loaded"
fi

echo ""
echo "4. Checking for TPM device:"
ls -l /dev/tpm* 2>/dev/null || echo "   ERROR: No /dev/tpm* device found"

echo ""
echo "5. Checking OP-TEE device:"
ls -l /dev/tee* 2>/dev/null || echo "   ERROR: No /dev/tee* device found"

echo ""
echo "6. Checking dmesg for TPM/TEE messages:"
dmesg | grep -i "tpm\|optee\|tee" | tail -30

echo ""
echo "7. Checking for TPM-specific errors:"
dmesg | grep -i "tpm_ftpm_tee\|ftpm"

echo ""
echo "8. Try manually probing tpm_ftpm_tee:"
echo "   Run: modprobe -r tpm_ftpm_tee && modprobe tpm_ftpm_tee"

echo ""
echo "=== End of fTPM Check ==="
