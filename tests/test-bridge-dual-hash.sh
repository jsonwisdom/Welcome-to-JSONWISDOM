#!/usr/bin/env bash
set -euo pipefail

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

cat > "$tmp" <<'JSON'
{"case_id":"2026-04-21-001","verdict":"Guilty"}
JSON

sha_a="$(scripts/jcs-hash.sh "$tmp")"
keccak_a="$(scripts/keccak-leaf.sh "$tmp")"

if [ -z "$sha_a" ] || [ -z "$keccak_a" ]; then
  echo "FAIL bridge hash missing"
  exit 1
fi

if [ "$sha_a" = "${keccak_a#0x}" ]; then
  echo "FAIL sha256 and keccak unexpectedly equal"
  exit 1
fi

echo "PASS bridge dual hash"
echo "SHA256=$sha_a"
echo "KECCAK256=$keccak_a"
