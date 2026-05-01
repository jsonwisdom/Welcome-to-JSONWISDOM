#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
EXAMPLES_DIR="$ROOT_DIR/examples"
OUTPUT_DIR="$ROOT_DIR/.truth"
LEAVES_FILE="$OUTPUT_DIR/leaves.txt"
ROOT_FILE="$OUTPUT_DIR/merkle-root.txt"
TREE_DIR="$OUTPUT_DIR/tree"
JCS_HASH="$ROOT_DIR/scripts/jcs-hash.sh"

mkdir -p "$OUTPUT_DIR" "$TREE_DIR"

if ! command -v sha256sum >/dev/null 2>&1; then
  echo "sha256sum is required"
  exit 1
fi

if [ ! -x "$JCS_HASH" ]; then
  echo "jcs-hash.sh is required and must be executable: $JCS_HASH"
  exit 1
fi

mapfile -t FILES < <(find "$EXAMPLES_DIR" -maxdepth 1 -type f -name '*.json' | sort)

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No JSON records found in $EXAMPLES_DIR"
  exit 1
fi

: > "$LEAVES_FILE"
for file in "${FILES[@]}"; do
  hash=$("$JCS_HASH" "$file")
  printf "%s  %s\n" "$hash" "$(basename "$file")" >> "$LEAVES_FILE"
done

cp "$LEAVES_FILE" "$TREE_DIR/level_0.txt"
level=0
current="$TREE_DIR/level_0.txt"

while true; do
  count=$(wc -l < "$current" | tr -d ' ')
  if [ "$count" -le 1 ]; then
    break
  fi

  next="$TREE_DIR/level_$((level + 1)).txt"
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

root=$(awk 'NR==1 {print $1}' "$current")
printf "%s\n" "$root" > "$ROOT_FILE"

echo "Leaves written to $LEAVES_FILE"
echo "Tree levels written to $TREE_DIR"
echo "Merkle root written to $ROOT_FILE"
echo "ROOT=$root"
