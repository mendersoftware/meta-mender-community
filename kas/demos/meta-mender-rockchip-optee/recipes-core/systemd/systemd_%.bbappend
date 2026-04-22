# Enable systemd cryptsetup and TPM2 support for fTPM-based disk encryption
PACKAGECONFIG:append:rock-4c-plus = " cryptsetup tpm2"
