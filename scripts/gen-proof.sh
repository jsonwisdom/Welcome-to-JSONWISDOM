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
current_hash="$LEAF"
level=0

while true; do
  current_file="$TREE_DIR/level_${level}.txt"
  next_file="$TREE_DIR/level_$((level + 1)).txt"

  if [ ! -f "$current_file" ]; then
    echo "Missing tree level: $current_file"
    exit 1
  fi

  mapfile -t lines < "$current_file"
  found_index=-1

  for i in "${!lines[@]}"; do
    hash=$(echo "${lines[$i]}" | awk '{print $1}')
    if [ "$hash" = "$current_hash" ]; then
      found_index=$i
      break
    fi
  done

  if [ "$found_index" -eq -1 ]; then
    echo "Leaf/hash not found at level $level"
    exit 1
  fi

  if [ ! -f "$next_file" ]; then
    break
  fi

  if [ $((found_index % 2)) -eq 0 ]; then
    sibling_index=$((found_index + 1))
    direction="R"
  else
    sibling_index=$((found_index - 1))
    direction="L"
  fi

  if [ "$sibling_index" -ge ${#lines[@]} ]; then
    sibling_hash=$(echo "${lines[$found_index]}" | awk '{print $1}')
  else
    sibling_hash=$(echo "${lines[$sibling_index]}" | awk '{print $1}')
  fi

  proof+=("${direction}:${sibling_hash}")

  if [ "$direction" = "R" ]; then
    current_hash=$(printf "%s%s" "$current_hash" "$sibling_hash" | sha256sum | awk '{print $1}')
  else
    current_hash=$(printf "%s%s" "$sibling_hash" "$current_hash" | sha256sum | awk '{print $1}')
  fi

  level=$((level + 1))
done

printf "%s\n" "${proof[@]}"
