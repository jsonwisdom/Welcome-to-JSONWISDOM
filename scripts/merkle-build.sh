#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
EXAMPLE_FILE="$ROOT_DIR/examples/sample-record.json"
OUTPUT_DIR="$ROOT_DIR/.truth"
LEAVES_FILE="$OUTPUT_DIR/leaves.txt"
ROOT_FILE="$OUTPUT_DIR/merkle-root.txt"

mkdir -p "$OUTPUT_DIR"

if [ ! -f "$EXAMPLE_FILE" ]; then
  echo "Missing example record: $EXAMPLE_FILE"
  exit 1
fi

if ! command -v sha256sum >/dev/null 2>&1; then
  echo "sha256sum is required"
  exit 1
fi

LEAF_HASH=$(tr -d '\n\r\t ' < "$EXAMPLE_FILE" | sha256sum | awk '{print $1}')
printf "%s\n" "$LEAF_HASH" > "$LEAVES_FILE"
printf "%s\n" "$LEAF_HASH" > "$ROOT_FILE"

echo "Leaf set written to $LEAVES_FILE"
echo "Merkle root written to $ROOT_FILE"
echo "ROOT=$LEAF_HASH"
