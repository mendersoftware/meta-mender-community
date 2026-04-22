#!/bin/bash
# Generate OP-TEE TA signing keys
# This script creates RSA key pair for signing OP-TEE Trusted Applications

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRIVATE_KEY="${SCRIPT_DIR}/ta_sign_key.pem"
PUBLIC_KEY="${SCRIPT_DIR}/ta_public_key.pem"

echo "Generating OP-TEE TA signing keys..."

# Generate 2048-bit RSA private key
echo "Creating private key: ${PRIVATE_KEY}"
openssl genpkey -algorithm RSA -out "${PRIVATE_KEY}" -pkeyopt rsa_keygen_bits:2048

# Extract public key
echo "Creating public key: ${PUBLIC_KEY}"
openssl rsa -in "${PRIVATE_KEY}" -pubout -out "${PUBLIC_KEY}"

# Set proper permissions
chmod 600 "${PRIVATE_KEY}"
chmod 644 "${PUBLIC_KEY}"

echo "Done! Keys generated:"
ls -lh "${PRIVATE_KEY}" "${PUBLIC_KEY}"
