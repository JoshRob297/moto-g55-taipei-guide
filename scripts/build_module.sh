#!/usr/bin/env bash
# ==============================================================================
# Build flashable Magisk module ZIP for Motorola Carrier & Telemetry Debloater
# Author: JoshRob
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
MODULE_DIR="$ROOT_DIR/magisk-module"
OUTPUT_ZIP="$ROOT_DIR/moto_g55_carrier_debloater_v2.0.zip"

if [ ! -d "$MODULE_DIR" ]; then
    echo "Error: magisk-module directory not found at $MODULE_DIR"
    exit 1
fi

echo "Building Magisk module ZIP..."
cd "$MODULE_DIR"
rm -f "$OUTPUT_ZIP" "$ROOT_DIR"/moto_g55_paks_immunity_*.zip
zip -r "$OUTPUT_ZIP" . -x "*.DS_Store" "*__MACOSX*"

echo "Successfully created: $OUTPUT_ZIP"
