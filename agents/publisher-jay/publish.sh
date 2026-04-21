#!/bin/bash
set -euo pipefail

DOMAIN=${PUBLISH_DOMAIN:-data.jaywisdom.eth}
RPC_URL=${PUBLISH_RPC_URL:-https://mainnet.base.org}
REGISTRY=${PUBLISH_REGISTRY:-0x5dC881d0A0291F90d01142b0575Aa4000FE5f547}

PROPOSALS_DIR="/app/proposals"
EXEC_DIR="$PROPOSALS_DIR/executed"
REJECT_DIR="$PROPOSALS_DIR/rejected"

mkdir -p "$EXEC_DIR" "$REJECT_DIR"

PROPOSAL=$(ls "$PROPOSALS_DIR"/PROPOSAL-*.json 2>/dev/null | sort | head -n1 || true)
[ -z "$PROPOSAL" ] && exit 0

echo "🚀 Agent C: Processing $PROPOSAL"

PREV_ROOT=$(jq -r .previous_root "$PROPOSAL")
NEW_ROOT=$(jq -r .new_root "$PROPOSAL")
NEW_CID=$(jq -r .new_cid "$PROPOSAL")

NAMEHASH=$(cast namehash "$DOMAIN")
RESOLVER=$(cast call --rpc-url "$RPC_URL" "$REGISTRY" "resolver(bytes32)" "$NAMEHASH" | tr -d '\n\r\t ')

if [ "$RESOLVER" = "0x0000000000000000000000000000000000000000" ]; then
  echo "🚨 No resolver set"
  mv "$PROPOSAL" "$REJECT_DIR/"
  exit 1
fi

CURRENT_CH=$(cast call --rpc-url "$RPC_URL" "$RESOLVER" "contenthash(bytes32)" "$NAMEHASH" | tr -d '\n\r\t ')
CURRENT_CID=$(cast contenthash-decode "$CURRENT_CH" 2>/dev/null || true)

if [ -z "$CURRENT_CID" ]; then
  echo "🚨 Failed to decode current CID"
  mv "$PROPOSAL" "$REJECT_DIR/"
  exit 1
fi

CURRENT_ROOT=$(ipfs cat "/ipfs/$CURRENT_CID/.truth/merkle-root.txt" 2>/dev/null | tr -d '\n\r\t ')

if [ "$PREV_ROOT" != "$CURRENT_ROOT" ]; then
  echo "🚨 DRIFT DETECTED: expected $PREV_ROOT got $CURRENT_ROOT"
  mv "$PROPOSAL" "$REJECT_DIR/"
  exit 1
fi

FETCH_ROOT=$(ipfs cat "/ipfs/$NEW_CID/.truth/merkle-root.txt" 2>/dev/null | tr -d '\n\r\t ')

if [ "$FETCH_ROOT" != "$NEW_ROOT" ]; then
  echo "🚨 CID CONTENT MISMATCH"
  mv "$PROPOSAL" "$REJECT_DIR/"
  exit 1
fi

ENCODED=$(cast contenthash-encode ipfs "$NEW_CID")

if [ "${DRY_RUN:-true}" = "true" ] || [ -z "${PRIVATE_KEY:-}" ]; then
  echo "✅ DRY RUN SUCCESS for root $NEW_ROOT"
  mv "$PROPOSAL" "$EXEC_DIR/$(basename "$PROPOSAL" .json)-DRYRUN.json"
  exit 0
fi

echo "✍️ Sending transaction..."
TX=$(cast send --rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY" "$RESOLVER" "setContenthash(bytes32,bytes)" "$NAMEHASH" "$ENCODED" --json | jq -r .transactionHash)

if [ -n "$TX" ] && [ "$TX" != "null" ]; then
  echo "🎉 SUCCESS: $TX"
  mv "$PROPOSAL" "$EXEC_DIR/$(basename "$PROPOSAL" .json)-$TX.json"
else
  echo "❌ EXECUTION FAILED"
  mv "$PROPOSAL" "$REJECT_DIR/"
fi
