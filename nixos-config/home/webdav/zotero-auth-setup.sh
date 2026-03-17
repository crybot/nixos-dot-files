#!/usr/bin/env bash
set -euo pipefail

mkdir -p "${CONFIG_DIR}"

echo "Setting up WebDAV credentials for Zotero sync..."
read -s -r -p "Enter WebDAV password: " PASSWORD
echo ""

# Obfuscate the password securely
OBFUSCATED=$(rclone obscure "$PASSWORD")

# Generate the EnvironmentFile for systemd
echo "RCLONE_CONFIG_OPENWRT_PASS=$OBFUSCATED" > "${CRED_FILE}"
chmod 600 "${CRED_FILE}"

echo "Authentication successful. State isolated at ${CRED_FILE}."
echo "The background daemon will now automatically initialize the sync on its next timer trigger."
