#!/bin/bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <leaf_hash> <proof...>"
  exit 1
fi

LEAF="$1"
shift
PROOF=("$@")

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOT_FILE="$ROOT_DIR/.truth/merkle-root.txt"

if [ ! -f "$ROOT_FILE" ]; then
  echo "Merkle root not found. Run merkle-build.sh first."
  exit 1
fi

EXPECTED_ROOT=$(cat "$ROOT_FILE" | tr -d '\n\r\t ')
current_hash="$LEAF"

for step in "${PROOF[@]}"; do
  direction=$(echo "$step" | cut -d':' -f1)
  sibling=$(echo "$step" | cut -d':' -f2)

  if [ "$direction" = "R" ]; then
    current_hash=$(printf "%s%s" "$current_hash" "$sibling" | sha256sum | awk '{print $1}')
  elif [ "$direction" = "L" ]; then
    current_hash=$(printf "%s%s" "$sibling" "$current_hash" | sha256sum | awk '{print $1}')
  else
    echo "Invalid proof direction: $direction"
    exit 1
  fi
done

if [ "$current_hash" = "$EXPECTED_ROOT" ]; then
  echo "✅ VERIFIED: recomputed root matches"
  exit 0
else
  echo "❌ FAILED: recomputed root mismatch"
  echo "Expected: $EXPECTED_ROOT"
  echo "Got:      $current_hash"
  exit 1
fi
