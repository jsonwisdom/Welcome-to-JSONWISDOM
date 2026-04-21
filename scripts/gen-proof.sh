#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <leaf_hash>"
  exit 1
fi

LEAF=$1
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TREE_DIR="$ROOT_DIR/.truth/tree"

if [ ! -d "$TREE_DIR" ]; then
  echo "Tree not found. Run merkle-build.sh first."
  exit 1
fi

proof=()
current_file="$TREE_DIR/level_0.txt"

while true; do
  mapfile -t lines < "$current_file"
  found_index=-1

  for i in "${!lines[@]}"; do
    hash=$(echo "${lines[$i]}" | awk '{print $1}')
    if [ "$hash" = "$LEAF" ]; then
      found_index=$i
      break
    fi
  done

  if [ "$found_index" -eq -1 ]; then
    break
  fi

  if [ $((found_index % 2)) -eq 0 ]; then
    sibling_index=$((found_index + 1))
  else
    sibling_index=$((found_index - 1))
  fi

  if [ "$sibling_index" -lt ${#lines[@]} ]; then
    sibling=$(echo "${lines[$sibling_index]}" | awk '{print $1}')
    proof+=("$sibling")
  fi

  next_level=$(basename "$current_file" | sed 's/level_//;s/.txt//')
  next_level=$((next_level + 1))
  next_file="$TREE_DIR/level_${next_level}.txt"

  if [ ! -f "$next_file" ]; then
    break
  fi

  LEAF=$(printf "%s%s" "$LEAF" "$sibling" | sha256sum | awk '{print $1}')
  current_file="$next_file"
done

printf "%s\n" "${proof[@]}"
