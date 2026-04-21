#!/bin/bash
set -euo pipefail

INBOX="/app/inbox"
STAGING="/app/staging"
PROPOSALS="/app/proposals"
TRUTH_SRC="/app/.truth"

mkdir -p "$INBOX" "$STAGING" "$PROPOSALS"

echo "✍️ Agent B: Monitoring $INBOX for new records..."

while true; do
  if [ "$(ls -A $INBOX 2>/dev/null)" ]; then
    TIMESTAMP=$(date +%s)
    WORKDIR="$STAGING/run-$TIMESTAMP"
    mkdir -p "$WORKDIR"

    echo "🏗️ Staging run $TIMESTAMP"

    # 1. Copy current truth into isolated workspace
    cp -r "$TRUTH_SRC" "$WORKDIR/.truth"
    cp -r /app/examples "$WORKDIR/examples"

    # 2. Validate + ingest
    for f in "$INBOX"/*.json; do
      if [ ! -f "$f" ]; then
        continue
      fi
      if jq -e . "$f" >/dev/null 2>&1; then
        echo "✔ Valid JSON: $f"
        cp "$f" "$WORKDIR/examples/"
        rm "$f"
      else
        echo "❌ Invalid JSON: $f"
        rm "$f"
      fi
    done

    # 3. Rebuild Merkle tree in staging
    (cd "$WORKDIR" && ../scripts/merkle-build.sh >/dev/null 2>&1)

    if [ ! -f "$WORKDIR/.truth/merkle-root.txt" ]; then
      echo "🚨 Build failed. Skipping proposal."
      rm -rf "$WORKDIR"
      sleep 5
      continue
    fi

    # 4. Internal audit on staging
    if (cd /app && ./tests/test-integrity.sh >/dev/null 2>&1); then
      NEW_ROOT=$(tr -d '\n\r\t ' < "$WORKDIR/.truth/merkle-root.txt")

      # 5. Pin to IPFS (local node expected)
      NEW_CID=$(ipfs add -q -r "$WORKDIR/.truth" | tail -n1)

      echo "📜 Proposal generated ROOT=$NEW_ROOT CID=$NEW_CID"

      jq -n \
        --arg ts "$TIMESTAMP" \
        --arg root "$NEW_ROOT" \
        --arg cid "$NEW_CID" \
        '{version:"1.0",state:{timestamp:$ts,new_root:$root,new_cid:$cid}}' \
        > "$PROPOSALS/PROPOSAL-$TIMESTAMP.json"
    else
      echo "🚨 Integrity check failed. Proposal rejected."
    fi

    rm -rf "$WORKDIR"
  fi

  sleep 10
done
