#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$ROOT_DIR/.truth"

if ! command -v ipfs >/dev/null 2>&1; then
  echo "IPFS CLI not found. Install Kubo (ipfs) first."
  exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "Missing .truth directory. Run merkle-build.sh first."
  exit 1
fi

CID=$(ipfs add -r "$TARGET_DIR" | tail -n 1 | awk '{print $2}')

echo "📦 Published to IPFS"
echo "CID=$CID"

echo "$CID" > "$TARGET_DIR/ipfs-cid.txt"
