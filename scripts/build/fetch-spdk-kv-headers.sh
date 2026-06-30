#!/bin/bash
# Script to fetch the SPDK NVMe spec header (Key-Value command set definitions)
# Copyright (c) 2026 IBM Corporation
# SPDX-License-Identifier: MIT

set -e

SPDK_REPO="https://raw.githubusercontent.com/spdk/spdk/master"
OUTPUT_DIR="$1"

if [ -z "$OUTPUT_DIR" ]; then
    echo "Usage: $0 <output_directory>"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Fetching SPDK NVMe spec header (Key-Value command set)..."

# The NVMe Key-Value Command Set opcodes and status codes live in SPDK's public
# nvme_spec.h (enum spdk_nvme_kv_opcode; the 0x85-0x89 KV status codes). The
# Linux kernel's linux/nvme.h has no KV uAPI, so SPDK is the upstream source for
# these standard definitions. extract-nvme-defines.sh pulls them into
# nvme-ep-generated.h so they cannot drift from the spec; only the vendor KV
# Exec opcode (0x83), which SPDK does not define, stays hand-written in
# src/include/nvme-kv.h.
echo "  - Downloading include/spdk/nvme_spec.h..."
curl -sS "${SPDK_REPO}/include/spdk/nvme_spec.h" -o "${OUTPUT_DIR}/spdk-nvme_spec.h"

echo "Successfully downloaded SPDK NVMe spec header to ${OUTPUT_DIR}/"
echo ""
echo "Downloaded files:"
echo "  - spdk-nvme_spec.h (SPDK NVMe spec: KV command set opcodes/status codes)"
