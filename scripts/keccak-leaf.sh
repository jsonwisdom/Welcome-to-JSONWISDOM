#!/usr/bin/env bash
set -euo pipefail

CANONICALIZE_SCRIPT="$(dirname "$0")/canonicalize-json.mjs"

if ! command -v cast >/dev/null 2>&1; then
  echo "cast is required for Ethereum keccak256 hashing" >&2
  exit 1
fi

if [ $# -eq 1 ] && [ -f "$1" ]; then
  node "$CANONICALIZE_SCRIPT" < "$1" | cast keccak
else
  node "$CANONICALIZE_SCRIPT" | cast keccak
fi
