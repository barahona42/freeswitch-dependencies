#!/usr/bin/env bash
set -u

source .local/.env

test -s $WEBHOOK_URL

TEXT="$1"

data=$(jq -nrc --arg text "$TEXT" --arg logtail "$(printf "\`\`\`%s\`\`\`" "$(cat customizations.sh)")" '{"blocks":[{"type":"divider"},{"type":"section","text":{"type":"mrkdwn","text":$text}},{"type":"divider"},{"type":"section","text":{"type":"mrkdwn","text":$logtail}}]}')
curl -f -X POST -H 'Content-Type: application/json' --data "$data" "$WEBHOOK_URL"
