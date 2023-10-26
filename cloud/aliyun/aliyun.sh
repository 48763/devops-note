#/bin/bash
AC="default josannlinnie furmongerdaiva piggotttylan"

balance() {
    aliyun bssopenapi QueryAccountBalance --profile $1
}

OPTOKEN="TCVQNSS7R/B019QCV5JD6/A1QT1PpP6zxmtn05OyiQZQoE"
limit=200000

for ac in $AC
do
    cash=$(balance $ac | jq -r .Data.AvailableCashAmount | sed 's/[[:punct:]]//g')
    echo "$ac 剩餘 $(( $cash / 100 ))元"

    if [ $limit -gt $cash ]; then
        curl -X POST \
            --data-urlencode "payload={\"username\":\"阿里雲($ac)\",\"text\": \"阿里雲該儲值囉!! 剩餘 $(( $cash / 100 )) 元\"}" \
            https://hooks.slack.com/services/${OPTOKEN} >/dev/null 2>&1
    fi
done