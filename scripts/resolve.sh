#!/bin/bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <ens_name> [rpc_url]"
  echo "Example: $0 data.jaywisdom.eth https://mainnet.base.org"
  exit 1
fi

DOMAIN="$1"
RPC_URL="${2:-https://mainnet.base.org}"
REGISTRY="0x5dC881d0A0291F90d01142b0575Aa4000FE5f547"
NAMEHASH=$(cast namehash "$DOMAIN")

if ! command -v cast >/dev/null 2>&1; then
  echo "Foundry cast is required"
  exit 1
fi

RESOLVER=$(cast call --rpc-url "$RPC_URL" "$REGISTRY" "resolver(bytes32)" "$NAMEHASH" | tail -n 1)

if [ "$RESOLVER" = "0x0000000000000000000000000000000000000000" ]; then
  echo "No resolver set for $DOMAIN"
  exit 1
fi

RAW=$(cast call --rpc-url "$RPC_URL" "$RESOLVER" "contenthash(bytes32)" "$NAMEHASH")
CID=$(cast contenthash-decode "$RAW")

echo "DOMAIN=$DOMAIN"
echo "RESOLVER=$RESOLVER"
echo "CID=$CID"
