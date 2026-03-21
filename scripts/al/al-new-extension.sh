#!/usr/bin/env bash
# al-new-extension.sh — Scaffold a new AL extension from the devlab template.
#
# Usage:
#   ./al-new-extension.sh --name "My Extension" --publisher "MyPublisher" --output ./my-extension
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(cd "${SCRIPT_DIR}/../../templates/al-extension" && pwd)"

usage() {
  echo "Usage: $0 --name <name> --publisher <publisher> [--output <dir>]"
  echo
  echo "Options:"
  echo "  --name        Extension display name (required)"
  echo "  --publisher   Publisher name (required)"
  echo "  --output      Output directory (default: ./<slugified-name>)"
  exit 1
}

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//'
}

# Parse arguments
EXT_NAME=""
EXT_PUBLISHER=""
OUTPUT_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)      EXT_NAME="$2"; shift 2 ;;
    --publisher) EXT_PUBLISHER="$2"; shift 2 ;;
    --output)    OUTPUT_DIR="$2"; shift 2 ;;
    -h|--help)   usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

[[ -z "$EXT_NAME" || -z "$EXT_PUBLISHER" ]] && usage

SLUG="$(slugify "$EXT_NAME")"
OUTPUT_DIR="${OUTPUT_DIR:-./${SLUG}}"

if [[ -d "$OUTPUT_DIR" ]]; then
  echo "Error: Output directory '$OUTPUT_DIR' already exists." >&2
  exit 1
fi

echo "Creating AL extension scaffold..."
echo "  Name:      $EXT_NAME"
echo "  Publisher: $EXT_PUBLISHER"
echo "  Output:    $OUTPUT_DIR"
echo

# Copy template
cp -r "$TEMPLATE_DIR" "$OUTPUT_DIR"

# Generate a new GUID
if command -v uuidgen &>/dev/null; then
  NEW_GUID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
elif command -v python3 &>/dev/null; then
  NEW_GUID="$(python3 -c 'import uuid; print(uuid.uuid4())')"
else
  NEW_GUID="$(cat /proc/sys/kernel/random/uuid 2>/dev/null || echo "00000000-0000-0000-0000-000000000000")"
fi

# Patch app.json
APP_JSON="$OUTPUT_DIR/app.json"
sed -i "s/\"00000000-0000-0000-0000-000000000000\"/\"${NEW_GUID}\"/" "$APP_JSON"
sed -i "s/\"My Extension\"/\"${EXT_NAME}\"/" "$APP_JSON"
sed -i "s/\"MyPublisher\"/\"${EXT_PUBLISHER}\"/" "$APP_JSON"

echo "Done! Scaffold created at: $OUTPUT_DIR"
echo
echo "Next steps:"
echo "  1. cd $OUTPUT_DIR"
echo "  2. Open in VS Code"
echo "  3. Run 'AL: Download Symbols' (Ctrl+Shift+P)"
echo "  4. Build with Ctrl+Shift+B"
