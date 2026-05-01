#!/usr/bin/env bash
set -euo pipefail

CANONICALIZE_SCRIPT="$(dirname "$0")/canonicalize-json.mjs"

if [ $# -eq 1 ] && [ -f "$1" ]; then
  node "$CANONICALIZE_SCRIPT" < "$1" | sha256sum | awk '{print $1}'
else
  node "$CANONICALIZE_SCRIPT" | sha256sum | awk '{print $1}'
fi
