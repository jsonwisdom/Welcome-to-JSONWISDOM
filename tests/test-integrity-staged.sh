#!/bin/bash
set -euo pipefail

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
trap 'rm -rf "$TMP_DIR"' EXIT

mkdir -p "$TMP_DIR/.truth" "$TMP_DIR/tree"

JCS_HASH="$WORKDIR/scripts/jcs-hash.sh"
if [ ! -x "$JCS_HASH" ]; then
  # Fallback to current directory scripts if not in WORKDIR
  JCS_HASH="$(cd "$(dirname "$0")/.." && pwd)/scripts/jcs-hash.sh"
fi

find "$WORKDIR/examples" -maxdepth 1 -type f -name '*.json' | sort | while read -r file; do
  hash=$("$JCS_HASH" "$file")
  printf "%s  %s\n" "$hash" "$(basename "$file")"
done > "$TMP_DIR/.truth/leaves.txt"

cp "$TMP_DIR/.truth/leaves.txt" "$TMP_DIR/tree/level_0.txt"
current="$TMP_DIR/tree/level_0.txt"
level=0

while true; do
  count=$(wc -l < "$current" | tr -d ' ')
  if [ "$count" -le 1 ]; then
    break
  fi

  next="$TMP_DIR/tree/level_$((level + 1)).txt"
  : > "$next"
  mapfile -t lines < "$current"
  i=0
  while [ $i -lt ${#lines[@]} ]; do
    left_hash=$(echo "${lines[$i]}" | awk '{print $1}')
    if [ $((i + 1)) -lt ${#lines[@]} ]; then
      right_hash=$(echo "${lines[$((i + 1))]}" | awk '{print $1}')
    else
      right_hash="$left_hash"
    fi
    parent_hash=$(printf "%s%s" "$left_hash" "$right_hash" | sha256sum | awk '{print $1}')
    printf "%s\n" "$parent_hash" >> "$next"
    i=$((i + 2))
  done
  level=$((level + 1))
  current="$next"
done

ACTUAL_ROOT=$(awk 'NR==1 {print $1}' "$current" | tr -d '\n\r\t ')

echo "EXPECTED=$EXPECTED_ROOT"
echo "ACTUAL=$ACTUAL_ROOT"

if [ "$EXPECTED_ROOT" = "$ACTUAL_ROOT" ]; then
  echo "STAGED INTEGRITY CONFIRMED"
  exit 0
else
  echo "STAGED INTEGRITY FAILED"
  exit 1
fi
