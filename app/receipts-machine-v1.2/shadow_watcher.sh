#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALERT_SCRIPT="${SCRIPT_DIR}/alert_webhook.sh"
ANCHOR_ADDRESS="0x18fA0E773955d48C9FB9C84916cB7A0ebDb17A4D"
EXPECTED_ROOT="0x34c7bd2850e04053a0db6a5cf61b38101f801d4f045f03c9c05fd676c636fca4"
EXPECTED_CID="bafybeif6hgbjq27u3clnevui32bs7cv6moikw2fqfhlylt5qoej33p5bke"
BASE_RPC="${BASE_RPC_URL:-https://mainnet.base.org}"
IPFS_GATEWAY="${IPFS_GATEWAY:-https://ipfs.io/ipfs/}"
LOG_FILE="${SCRIPT_DIR}/shadow.log"
log(){ echo "[$(date -Iseconds)] $1" | tee -a "$LOG_FILE"; }
log_info(){ log "[INFO] $1"; }
log_ok(){ log "[OK] $1"; }
log_warn(){ log "[WARN] $1"; }
log_error(){ log "[ERROR] $1"; }
send_alert(){ if [[ -x "$ALERT_SCRIPT" ]]; then "$ALERT_SCRIPT" "$@" >/dev/null 2>&1 || true; fi; }
fetch(){ curl -sL --max-time 30 --retry 3 "$IPFS_GATEWAY$1"; }
get_state(){ cast call --rpc-url "$BASE_RPC" "$ANCHOR_ADDRESS" "getAnchorState()((bytes32,bytes32,bytes32,string,uint256,uint256,uint256))"; }
main(){
  log_info "=========================================="
  log_info "RMP1 SHADOW WATCHER v1.2"
  log_info "=========================================="
  if ! command -v cast >/dev/null 2>&1; then
    log_error "cast not found"
    send_alert "FATAL" "Watcher Prerequisite" "cast not installed"
    exit 1
  fi
  local state oc cid last tmp comp silence now
  if ! state=$(get_state 2>/dev/null); then
    log_error "Anchor query failed"
    send_alert "ERROR" "Anchor Query Failed" "Could not read $ANCHOR_ADDRESS"
    exit 1
  fi
  oc=$(echo "$state" | cut -d',' -f1 | tr -d '[:space:]')
  cid=$(echo "$state" | cut -d',' -f4 | tr -d '[:space:]')
  last=$(echo "$state" | cut -d',' -f7 | tr -d '[:space:]')
  log_info "On-chain root: $oc"
  log_info "On-chain CID:  $cid"
  now=$(date +%s)
  silence=$((now - last))
  if [[ $silence -gt 93600 ]]; then
    log_warn "Watcher silence: ${silence}s (>26h)"
    send_alert "WARN" "Watcher Silence" "Last heartbeat: ${silence}s ago"
  fi
  if [[ "$oc" != "$EXPECTED_ROOT" ]]; then
    log_error "DIVERGENCE: ON-CHAIN ROOT"
    log_error "Expected: $EXPECTED_ROOT"
    log_error "Actual:   $oc"
    send_alert "ERROR" "RMP1 Divergence" "Context: ON-CHAIN ROOT | Expected: $EXPECTED_ROOT | Actual: $oc"
    exit 1
  fi
  if [[ "$cid" != "$EXPECTED_CID" ]]; then
    log_error "DIVERGENCE: ON-CHAIN CID"
    log_error "Expected: $EXPECTED_CID"
    log_error "Actual:   $cid"
    send_alert "ERROR" "RMP1 Divergence" "Context: ON-CHAIN CID | Expected: $EXPECTED_CID | Actual: $cid"
    exit 1
  fi
  log_ok "On-chain state matches expected genesis"
  tmp=$(mktemp)
  trap 'rm -f "$tmp"' EXIT
  log_info "Fetching IPFS: $EXPECTED_CID"
  if ! fetch "$EXPECTED_CID" > "$tmp"; then
    log_error "IPFS fetch failed"
    send_alert "ERROR" "IPFS Fetch Failed" "Could not retrieve $EXPECTED_CID"
    exit 1
  fi
  log_ok "Payload fetched: $(wc -c < "$tmp") bytes"
  comp=$(python3 - "$tmp" <<'PY'
import json,sys,hashlib
with open(sys.argv[1], 'r') as f:
    p=json.load(f)
prev=p.get('prev_root','0x'+'0'*64)
cur=bytes.fromhex(prev[2:]) if prev!='0x'+'0'*64 else b'\x00'*32
for r in p['records']:
    c=json.dumps(r, sort_keys=True, separators=(',', ':')).encode()
    cur=hashlib.sha256(b'RMP1:' + cur + c).digest()
print('0x' + cur.hex())
PY
)
  log_info "Computed root: $comp"
  if [[ "$comp" != "$EXPECTED_ROOT" ]]; then
    log_error "DIVERGENCE: COMPUTED ROOT"
    log_error "Expected: $EXPECTED_ROOT"
    log_error "Actual:   $comp"
    send_alert "ERROR" "RMP1 Divergence" "Context: COMPUTED ROOT | Expected: $EXPECTED_ROOT | Actual: $comp"
    exit 1
  fi
  log_ok "=========================================="
  log_ok "VERIFICATION COMPLETE - SYSTEM NOMINAL"
  log_ok "=========================================="
  log_ok "Anchor: $ANCHOR_ADDRESS"
  log_ok "Root:   $EXPECTED_ROOT"
  log_ok "CID:    $EXPECTED_CID"
  log_ok "=========================================="
  send_alert "INFO" "Heartbeat OK" "Root: $EXPECTED_ROOT | CID: $EXPECTED_CID"
}
main "$@"
