#!/bin/bash
set -euo pipefail

DOMAIN=${WATCH_DOMAIN:-data.jaywisdom.eth}
INTERVAL=${WATCH_INTERVAL:-60}

ROOT_DIR="/data"
LOCAL_ROOT_FILE="$ROOT_DIR/.truth/merkle-root.txt"
AUDIT_LOG="$ROOT_DIR/.truth/audit.log"

mkdir -p "$(dirname "$AUDIT_LOG")"

log() {
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) $1" | tee -a "$AUDIT_LOG"
}

resolve_cid() {
  # simple gateway fallback instead of cast (lighter container)
  curl -s "https://cloudflare-ipfs.com/ipns/$DOMAIN" 2>/dev/null || true
}

fetch_remote_root() {
  local cid="$1"
  curl -s "https://ipfs.io/ipfs/$cid/.truth/merkle-root.txt" | tr -d '\n\r\t '
}

while true; do
  if [ ! -f "$LOCAL_ROOT_FILE" ]; then
    log "LOCAL ROOT MISSING"
    sleep "$INTERVAL"
    continue
  fi

  LOCAL_ROOT=$(cat "$LOCAL_ROOT_FILE" | tr -d '\n\r\t ')

  CID=$(resolve_cid)
  if [ -z "$CID" ]; then
    log "FAILED TO RESOLVE CID"
    sleep "$INTERVAL"
    continue
  fi

  REMOTE_ROOT=$(fetch_remote_root "$CID")

  if [ "$LOCAL_ROOT" = "$REMOTE_ROOT" ]; then
    log "OK ROOT MATCH CID=$CID"
  else
    log "ALERT ROOT MISMATCH CID=$CID LOCAL=$LOCAL_ROOT REMOTE=$REMOTE_ROOT"
  fi

  sleep "$INTERVAL"
done
