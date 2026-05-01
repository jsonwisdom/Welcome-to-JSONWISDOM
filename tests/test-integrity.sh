#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if [ ! -f .truth/merkle-root.txt ]; then
  echo "LOCAL ROOT MISSING"
  exit 1
fi

TMP_DIR=$(mktemp -d)
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

EXPECTED_ROOT=$(tr -d '\n\r\t ' < .truth/merkle-root.txt)

BACKUP_TRUTH="$TMP_DIR/original_truth"
mv .truth "$BACKUP_TRUTH"

mkdir -p .truth
if ./scripts/merkle-build.sh >/tmp/merkle-build.log 2>&1; then
  if [ ! -f .truth/merkle-root.txt ]; then
    rm -rf .truth
    mv "$BACKUP_TRUTH" .truth
    echo "REBUILD FAILED: ROOT NOT GENERATED"
    exit 1
  fi
  ACTUAL_ROOT=$(tr -d '\n\r\t ' < .truth/merkle-root.txt)
else
  rm -rf .truth
  mv "$BACKUP_TRUTH" .truth
  cat /tmp/merkle-build.log
  echo "REBUILD FAILED"
  exit 1
fi

rm -rf .truth
mv "$BACKUP_TRUTH" .truth

if [ "$EXPECTED_ROOT" = "$ACTUAL_ROOT" ]; then
  echo "INTERNAL INTEGRITY CONFIRMED"
  exit 0
else
  echo "LOCAL CORRUPTION DETECTED"
  echo "EXPECTED=$EXPECTED_ROOT"
  echo "ACTUAL=$ACTUAL_ROOT"
  exit 1
fi
