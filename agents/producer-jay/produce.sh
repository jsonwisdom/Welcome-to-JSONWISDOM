#!/bin/bash
set -euo pipefail

INBOX="/app/inbox"
REJECTED="/app/inbox/rejected"
STAGING="/app/staging"
PROPOSALS="/app/proposals"
TRUTH_SRC="/app/.truth"

mkdir -p "$INBOX" "$REJECTED" "$STAGING" "$PROPOSALS"

echo "✍️ Agent B: Auditable Producer watching $INBOX"

while true; do
  if [ "$(ls -A $INBOX/*.json 2>/dev/null)" ]; then
    TS=$(date +%s)
    WORKDIR="$STAGING/run-$TS"
    mkdir -p "$WORKDIR"

    echo "🏗️ Staging run $TS"

    cp -r "$TRUTH_SRC" "$WORKDIR/.truth"
    cp -r /app/examples "$WORKDIR/examples"

    for f in $INBOX/*.json; do
      if [ ! -f "$f" ]; then continue; fi
      if jq -e . "$f" >/dev/null 2>&1; then
        echo "✔ Accept: $f"
        cp "$f" "$WORKDIR/examples/"
        rm "$f"
      else
        echo "❌ Reject: $f"
        mv "$f" "$REJECTED/"
      fi
    done

    (cd "$WORKDIR" && ../scripts/merkle-build.sh >/dev/null 2>&1)

    if [ ! -f "$WORKDIR/.truth/merkle-root.txt" ]; then
      echo "🚨 Build failed"
      rm -rf "$WORKDIR"
      sleep 5
      continue
    fi

    MANIFEST=$(cd "$WORKDIR" && ../scripts/make-manifest.sh)

    if (cd /app && ./tests/test-integrity.sh >/dev/null 2>&1); then
      NEW_ROOT=$(tr -d '\n\r\t ' < "$WORKDIR/.truth/merkle-root.txt")
      PREV_ROOT=$(tr -d '\n\r\t ' < "$TRUTH_SRC/merkle-root.txt")
      NEW_CID=$(ipfs add -q -r "$WORKDIR/.truth" | tail -n1)

      echo "📜 Proposal ROOT=$NEW_ROOT CID=$NEW_CID"

      jq -n \
        --arg ts "$TS" \
        --arg pr "$PREV_ROOT" \
        --arg nr "$NEW_ROOT" \
        --arg nc "$NEW_CID" \
        --argjson man "$MANIFEST" \
        '{version:"1.0",timestamp:$ts,previous_root:$pr,new_root:$nr,new_cid:$nc,manifest:$man}' \
        > "$PROPOSALS/PROPOSAL-$TS.json"
    else
      echo "🚨 Integrity check failed. Proposal aborted."
    fi

    rm -rf "$WORKDIR"
  fi

  sleep 10
done
