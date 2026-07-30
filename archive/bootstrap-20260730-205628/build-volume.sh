#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VOLUME_NAME="${1:-}"
VERSION="$(tr -d '[:space:]' < "$ROOT_DIR/VERSION")"

if [[ -z "$VOLUME_NAME" ]]; then
    echo "Usage: $0 <volume-directory-name>"
    echo "Example: $0 Volume-I-JupyterHub"
    exit 1
fi

VOLUME_DIR="$ROOT_DIR/volumes/$VOLUME_NAME"
CHAPTER_DIR="$VOLUME_DIR/chapters"
METADATA_FILE="$VOLUME_DIR/metadata.yaml"
OUTPUT_DIR="$ROOT_DIR/output/pdf"

if [[ ! -d "$VOLUME_DIR" ]]; then
    echo "ERROR: Volume directory not found: $VOLUME_DIR" >&2
    exit 1
fi

if [[ ! -f "$METADATA_FILE" ]]; then
    echo "ERROR: Metadata file not found: $METADATA_FILE" >&2
    exit 1
fi

mapfile -t CHAPTERS < <(
    find "$CHAPTER_DIR" -maxdepth 1 -type f -name '*.md' -print | sort
)

if [[ ${#CHAPTERS[@]} -eq 0 ]]; then
    echo "ERROR: No Markdown chapters found in $CHAPTER_DIR" >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

SAFE_NAME="${VOLUME_NAME//-/_}"
OUTPUT_FILE="$OUTPUT_DIR/Donnager_Administrators_Handbook_${SAFE_NAME}_v${VERSION}.pdf"

cd "$ROOT_DIR"

echo "Building $VOLUME_NAME..."
echo "Version: $VERSION"
echo "Chapters: ${#CHAPTERS[@]}"

pandoc \
    --defaults="$ROOT_DIR/styles/pdf-defaults.yaml" \
    --metadata-file="$METADATA_FILE" \
    --resource-path="$ROOT_DIR:$VOLUME_DIR:$CHAPTER_DIR:$ROOT_DIR/assets" \
    "${CHAPTERS[@]}" \
    --output="$OUTPUT_FILE"

echo
echo "Created:"
echo "$OUTPUT_FILE"
