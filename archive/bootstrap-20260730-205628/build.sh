#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VOLUMES=(
    "Volume-I-JupyterHub"
)

for volume in "${VOLUMES[@]}"; do
    "$ROOT_DIR/build-volume.sh" "$volume"
done

echo
echo "All configured handbook volumes built successfully."
