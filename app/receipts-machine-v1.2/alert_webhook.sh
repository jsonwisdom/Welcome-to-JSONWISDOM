#!/bin/bash
set -euo pipefail
DISCORD_WEBHOOK="${DISCORD_WEBHOOK_URL:-}"
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"
ALERT_LEVEL="${1:-WARN}"
ALERT_TITLE="${2:-RMP1 Watcher Alert}"
ALERT_MESSAGE="${3:-Divergence detected}"
send_discord(){
  if [[ -z "$DISCORD_WEBHOOK" ]]; then return 0; fi
  curl -s -H "Content-Type: application/json" -X POST \
    -d "{\"content\":\"[$ALERT_LEVEL] $ALERT_TITLE\\n$ALERT_MESSAGE\"}" \
    "$DISCORD_WEBHOOK" >/dev/null || true
}
send_telegram(){
  if [[ -z "$TELEGRAM_BOT_TOKEN" || -z "$TELEGRAM_CHAT_ID" ]]; then return 0; fi
  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d "chat_id=$TELEGRAM_CHAT_ID" \
    --data-urlencode "text=[$ALERT_LEVEL] $ALERT_TITLE
$ALERT_MESSAGE" >/dev/null || true
}
echo "[ALERT] $ALERT_LEVEL: $ALERT_TITLE"
echo "$ALERT_MESSAGE"
send_discord
send_telegram
