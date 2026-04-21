#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

WORKDIR="${1:-}"
if [ -z "$WORKDIR" ]; then
  echo "Usage: $0 <staging_workdir>"
  exit 1
fi

if [ ! -d "$WORKDIR" ]; then
  echo "Missing staging directory: $WORKDIR"
  exit 1
fi

if [ ! -f "$WORKDIR/.truth/merkle-root.txt" ]; then
  echo "Missing staged root: $WORKDIR/.truth/merkle-root.txt"
  exit 1
fi

EXPECTED_ROOT=$(tr -d '\n\r\t ' < "$WORKDIR/.truth/merkle-root.txt")
TMP_DIR=$(mktemp -d)
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

mkdir -p "$TMP_DIR"
cp -r "$WORKDIR/examples" "$TMP_DIR/examples"
mkdir -p "$TMP_DIR/.truth"
cp "$REPO_ROOT/scripts/merkle-build.sh" "$TMP_DIR/merkle-build.sh"
chmod +x "$TMP_DIR/merkle-build.sh"

(
  cd "$TMP_DIR"
  ./merkle-build.sh >/tmp/staged-merkle-build.log 2>&1
)

if [ ! -f "$TMP_DIR/.truth/merkle-root.txt" ]; then
  cat /tmp/staged-merkle-build.log 2>/dev/null || true
  echo "STAGED REBUILD FAILED"
  exit 1
fi

ACTUAL_ROOT=$(tr -d '\n\r\t ' < "$TMP_DIR/.truth/merkle-root.txt")

if [ "$EXPECTED_ROOT" = "$ACTUAL_ROOT" ]; then
  echo "STAGED INTEGRITY CONFIRMED"
  exit 0
else
  echo "STAGED INTEGRITY FAILED"
  echo "EXPECTED=$EXPECTED_ROOT"
  echo "ACTUAL=$ACTUAL_ROOT"
  exit 1
fi
