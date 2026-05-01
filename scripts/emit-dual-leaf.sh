#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ] || [ ! -f "$1" ]; then
  echo "Usage: $0 <record.json>" >&2
  exit 1
fi

file="$1"
sha256_leaf="$(scripts/jcs-hash.sh "$file")"
keccak_leaf="$(scripts/keccak-leaf.sh "$file")"

printf '{'
printf '"file":"%s",' "$(basename "$file")"
printf '"leaf_sha256":"%s",' "$sha256_leaf"
printf '"leaf_keccak256":"%s",' "$keccak_leaf"
printf '"binding":"same_rfc8785_jcs_bytes"'
printf '}\n'
