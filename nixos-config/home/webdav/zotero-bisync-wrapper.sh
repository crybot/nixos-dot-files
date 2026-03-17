#!/usr/bin/env bash
set -euo pipefail

# Abort if the user hasn't authenticated yet
if [ ! -f "${CRED_FILE}" ]; then
    echo "Credentials missing. Please run 'zotero-auth-setup' first."
    exit 1
fi

# Evaluate the state boundary to determine the execution mode
if [ ! -f "${MARKER_FILE}" ]; then
    echo "Initial state mapping not found. Executing --resync baseline..."
    rclone bisync "${SYNC_DIR}" openwrt: \
        --resync \
        --verbose \
        --create-empty-src-dirs \
        --compare size,modtime

    # Assert the marker strictly upon successful baseline creation
    touch "${MARKER_FILE}"
else
    rclone bisync "${SYNC_DIR}" openwrt: \
        --verbose \
        --create-empty-src-dirs \
        --compare size,modtime
fi
