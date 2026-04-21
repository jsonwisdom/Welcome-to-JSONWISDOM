#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <CID>"
  exit 1
fi

CID="$1"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOCAL_ROOT_FILE="$ROOT_DIR/.truth/merkle-root.txt"

if [ ! -f "$LOCAL_ROOT_FILE" ]; then
  echo "Local root not found. Run merkle-build.sh first."
  exit 1
fi

LOCAL_ROOT=$(cat "$LOCAL_ROOT_FILE" | tr -d '\n\r\t ')

GATEWAYS=(
  "https://ipfs.io/ipfs"
  "https://cloudflare-ipfs.com/ipfs"
  "https://gateway.pinata.cloud/ipfs"
)

for gw in "${GATEWAYS[@]}"; do
  echo "🔎 Checking $gw/$CID/.truth/merkle-root.txt"
  REMOTE_ROOT=$(curl -s "$gw/$CID/.truth/merkle-root.txt" | tr -d '\n\r\t ')

  if [ "$REMOTE_ROOT" = "$LOCAL_ROOT" ]; then
    echo "✅ MATCH on $gw"
  else
    echo "❌ MISMATCH on $gw"
  fi
  echo "---"
done
