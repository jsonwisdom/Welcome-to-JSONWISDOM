#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

./scripts/merkle-build.sh

LEAF=$(head -n 1 .truth/leaves.txt | awk '{print $1}')

PROOF=$(./scripts/gen-proof.sh "$LEAF")

# Good verification
./scripts/verify.sh "$LEAF" $PROOF

echo "--- Now corrupting leaf ---"
BAD_LEAF="${LEAF%?}0"

if ./scripts/verify.sh "$BAD_LEAF" $PROOF; then
  echo "❌ ERROR: Corruption NOT detected"
  exit 1
else
  echo "✅ SUCCESS: Corruption detected"
fi
