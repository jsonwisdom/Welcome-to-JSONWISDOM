#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOT_FILE="$ROOT_DIR/.truth/merkle-root.txt"

if [ $# -ne 1 ]; then
  echo "Usage: $0 <leaf_hash>"
  exit 1
fi

LEAF="$1"

if [ ! -f "$ROOT_FILE" ]; then
  echo "Merkle root not found. Run merkle-build.sh first."
  exit 1
fi

ROOT=$(cat "$ROOT_FILE" | tr -d '\n\r\t ')

if [ "$LEAF" = "$ROOT" ]; then
  echo "✅ Verified: leaf matches root (single-leaf tree)"
  exit 0
else
  echo "❌ Verification failed"
  echo "Expected root: $ROOT"
  echo "Got leaf:     $LEAF"
  exit 1
fi
