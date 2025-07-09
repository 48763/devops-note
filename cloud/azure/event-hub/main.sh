#!/bin/bash
EVENTHUB_NAMESPACE=""
EVENTHUB_INSTANCE=""
SHARED_ACCESS_KEY_NAME=""
SHARED_ACCESS_KEY=""

get_sas_token() {
    local EVENTHUB_URI="https://${EVENTHUB_NAMESPACE}.servicebus.windows.net/${EVENTHUB_INSTANCE}"

    local ENCODED_URI=$(echo -n ${EVENTHUB_URI} | jq -s -R -r @uri)
    local EXPIRY=${EXPIRY:=$((60 * 60 * 24))}
    local TTL=$(($(date +%s) + ${EXPIRY}))

    local UTF8_SIGNATURE=$(printf "%s\n%s" ${ENCODED_URI} ${TTL} | iconv -t utf8)

    local HASH=$(echo -n "${UTF8_SIGNATURE}" | openssl sha256 -hmac ${SHARED_ACCESS_KEY} -binary | base64)
    local ENCODED_HASH=$(echo -n ${HASH} | jq -s -R -r @uri)

    echo -n "SharedAccessSignature sr=${ENCODED_URI}&sig=${ENCODED_HASH}&se=${TTL}&skn=${SHARED_ACCESS_KEY_NAME}"
}

curl -X POST https://${EVENTHUB_NAMESPACE}.servicebus.windows.net/${EVENTHUB_INSTANCE}/messages \
   -H "Content-Type: application/json" \
   -H "ContentType: application/atom+xml;type=entry;charset=utf-8" \
   -H "Authorization: $(get_sas_token)" \
   --data-binary @log.json -iv
