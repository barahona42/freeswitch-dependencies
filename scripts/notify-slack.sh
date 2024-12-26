#!/usr/bin/env bash
set -eu

TEXT="$1"
data=$(jq -nrc --arg text "$TEXT" '{"blocks":[{"type":"divider"},{"type":"section","text":{"type":"mrkdwn","text":$text}},{"type":"divider"}]}')

# curl -X POST -H 'Content-Type: application/json' --data "$data" ""

# curl -X POST -H 'multipart/form-data' https://slack.com/api/files.upload

## i should send a notification on slack along with the make log file