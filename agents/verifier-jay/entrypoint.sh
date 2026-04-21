#!/bin/bash
set -euo pipefail

echo "🧾 Initializing IPFS node..."
ipfs init --profile lowpower >/dev/null 2>&1 || true

ipfs daemon --migrate=true &
IPFS_PID=$!

sleep 8

echo "🛡️ Starting Agent A (Sovereign Auditor)"
/app/agents/verifier-jay/watch.sh

wait $IPFS_PID
