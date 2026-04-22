#!/bin/bash
set -euo pipefail
GENESIS_ROOT="0x34c7bd2850e04053a0db6a5cf61b38101f801d4f045f03c9c05fd676c636fca4"
CID="bafybeif6hgbjq27u3clnevui32bs7cv6moikw2fqfhlylt5qoej33p5bke"
curl -sL https://ipfs.io/ipfs/$CID > g.json
python3 generate_leaf.py \
  --prev-root $GENESIS_ROOT \
  --prev-payload g.json \
  --new-record '{"type":"TEST","note":"advance"}' \
  --out leaf_test.json
cat leaf_test.json
