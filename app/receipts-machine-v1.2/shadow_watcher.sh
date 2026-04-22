#!/bin/bash
set -euo pipefail
ANCHOR_ADDRESS="0x18fA0E773955d48C9FB9C84916cB7A0ebDb17A4D"
EXPECTED_ROOT="0x34c7bd2850e04053a0db6a5cf61b38101f801d4f045f03c9c05fd676c636fca4"
EXPECTED_CID="bafybeif6hgbjq27u3clnevui32bs7cv6moikw2fqfhlylt5qoej33p5bke"
BASE_RPC="${BASE_RPC_URL:-https://mainnet.base.org}"
IPFS_GATEWAY="${IPFS_GATEWAY:-https://ipfs.io/ipfs/}"
LOG_FILE="./shadow.log"
log(){ echo "[$(date -Iseconds)] $1" | tee -a "$LOG_FILE"; }
fetch(){ curl -sL "$IPFS_GATEWAY$1"; }
root_onchain(){ cast call --rpc-url "$BASE_RPC" "$ANCHOR_ADDRESS" "getAnchorState()((bytes32,bytes32,bytes32,string,uint256,uint256,uint256))" | cut -d',' -f1 | tr -d ' '; }
main(){ log "Shadow start"; oc=$(root_onchain); log "Onchain root: $oc"; if [[ "$oc" != "$EXPECTED_ROOT" ]]; then log "DIVERGENCE"; exit 1; fi; tmp=$(mktemp); fetch "$EXPECTED_CID" > $tmp; comp=$(python3 - <<PY
import json,hashlib
p=json.load(open("$tmp"));cur=b"\x00"*32
for r in p["records"]:
 import json as j
 c=j.dumps(r,sort_keys=True,separators=(",",":")).encode()
 cur=hashlib.sha256(b"RMP1:"+cur+c).digest()
print("0x"+cur.hex())
PY
); log "Computed: $comp"; if [[ "$comp" != "$EXPECTED_ROOT" ]]; then log "INVALID"; exit 1; fi; log "OK"; }
main "$@"
