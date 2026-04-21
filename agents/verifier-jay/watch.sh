#!/bin/bash
set -euo pipefail

DOMAIN=${WATCH_DOMAIN:-data.jaywisdom.eth}
INTERVAL=${WATCH_INTERVAL:-60}
RPC_URL=${WATCH_RPC_URL:-https://mainnet.base.org}
REGISTRY=${WATCH_REGISTRY:-0x5dC881d0A0291F90d01142b0575Aa4000FE5f547}
ROOT_DIR="/data"
LOCAL_ROOT_FILE="$ROOT_DIR/.truth/merkle-root.txt"
AUDIT_LOG="$ROOT_DIR/.truth/audit.log"

mkdir -p "$(dirname "$AUDIT_LOG")"

log() {
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) $1" | tee -a "$AUDIT_LOG"
}

require_bin() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "MISSING DEPENDENCY $1"
    exit 1
  fi
}

resolve_cid() {
  local namehash resolver raw decoded
  namehash=$(cast namehash "$DOMAIN")
  resolver=$(cast call --rpc-url "$RPC_URL" "$REGISTRY" "resolver(bytes32)" "$namehash" | tr -d '\n\r\t ')

  if [ "$resolver" = "0x0000000000000000000000000000000000000000" ]; then
    log "NO RESOLVER SET FOR $DOMAIN"
    return 1
  fi

  raw=$(cast call --rpc-url "$RPC_URL" "$resolver" "contenthash(bytes32)" "$namehash" | tr -d '\n\r\t ')
  decoded=$(cast contenthash-decode "$raw" 2>/dev/null || true)

  if [ -z "$decoded" ]; then
    log "FAILED TO DECODE CONTENTHASH raw=$raw"
    return 1
  fi

  printf "%s" "$decoded"
}

fetch_remote_root() {
  local cid="$1"
  curl -s "https://ipfs.io/ipfs/$cid/.truth/merkle-root.txt" | tr -d '\n\r\t '
}

require_bin cast
require_bin curl

log "AGENT A START domain=$DOMAIN rpc=$RPC_URL"

while true; do
  if [ ! -f "$LOCAL_ROOT_FILE" ]; then
    log "LOCAL ROOT MISSING"
    sleep "$INTERVAL"
    continue
  fi

  LOCAL_ROOT=$(tr -d '\n\r\t ' < "$LOCAL_ROOT_FILE")

  CID=$(resolve_cid || true)
  if [ -z "$CID" ]; then
    log "FAILED TO RESOLVE CID"
    sleep "$INTERVAL"
    continue
  fi

  REMOTE_ROOT=$(fetch_remote_root "$CID")
  if [ -z "$REMOTE_ROOT" ]; then
    log "FAILED TO FETCH REMOTE ROOT CID=$CID"
    sleep "$INTERVAL"
    continue
  fi

  if [ "$LOCAL_ROOT" = "$REMOTE_ROOT" ]; then
    log "OK ROOT MATCH CID=$CID ROOT=$LOCAL_ROOT"
  else
    log "ALERT ROOT MISMATCH CID=$CID LOCAL=$LOCAL_ROOT REMOTE=$REMOTE_ROOT"
  fi

  sleep "$INTERVAL"
done
