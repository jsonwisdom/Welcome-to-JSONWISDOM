#!/bin/bash
set -e

echo "🔐 Verifying Merkle Proof..."

if [ -z "$1" ]; then
  echo "Usage: ./verify.sh <leaf_hash>"
  exit 1
fi

LEAF=$1

echo "Leaf: $LEAF"
echo "(Stub) Compare against stored Merkle root..."

echo "✅ Verification placeholder complete"
