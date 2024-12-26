#!/usr/bin/env bash
set -u

source .local/.env

test -s $WEBHOOK_URL

TEXT="$1"
TARGET_FILE="$2"

data=$(jq -nrc --arg text "$TEXT" --arg logtail "$(printf "\`\`\`%s\`\`\`" "$(tail -n5 $TARGET_FILE)")" '{"blocks":[{"type":"divider"},{"type":"section","text":{"type":"mrkdwn","text":$text}},{"type":"divider"},{"type":"section","text":{"type":"mrkdwn","text":$logtail}}]}')
curl -f -X POST -H 'Content-Type: application/json' --data "$data" "$WEBHOOK_URL"
