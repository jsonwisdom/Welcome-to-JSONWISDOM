#!/bin/bash
set -euo pipefail

PREV_DIR="${1:-../examples}"
CURR_DIR="${2:-examples}"

mkdir -p "$PREV_DIR" "$CURR_DIR"

ADDED=$(comm -13 <(find "$PREV_DIR" -maxdepth 1 -type f -name '*.json' -printf '%f\n' | sort) <(find "$CURR_DIR" -maxdepth 1 -type f -name '*.json' -printf '%f\n' | sort) | jq -R . | jq -s .)
DELETED=$(comm -23 <(find "$PREV_DIR" -maxdepth 1 -type f -name '*.json' -printf '%f\n' | sort) <(find "$CURR_DIR" -maxdepth 1 -type f -name '*.json' -printf '%f\n' | sort) | jq -R . | jq -s .)

MODIFIED=$(
  prev_tmp=$(mktemp)
  curr_tmp=$(mktemp)
  trap 'rm -f "$prev_tmp" "$curr_tmp"' EXIT

  find "$PREV_DIR" -maxdepth 1 -type f -name '*.json' -exec sha256sum {} \; | awk '{print $1" "gensub(/^.*\//,"",1,$2)}' | sort > "$prev_tmp"
  find "$CURR_DIR" -maxdepth 1 -type f -name '*.json' -exec sha256sum {} \; | awk '{print $1" "gensub(/^.*\//,"",1,$2)}' | sort > "$curr_tmp"

  join -j 2 -o 1.2,1.1,2.1 "$prev_tmp" "$curr_tmp" | awk '$2 != $3 {print $1}' | jq -R . | jq -s .
)

jq -n --argjson a "$ADDED" --argjson d "$DELETED" --argjson m "$MODIFIED" '{added:$a, deleted:$d, modified:$m}'
