#!/bin/bash
slack="TCVQNSS7R/B019QCV5JD6/A1QT1PpP6zxmtn05OyiQZQoE"
ac_list="ac001 ac002"
ac001="qwertyuiopqwertyuiop"
ac001_info="default"
ac002="asdfghjklasdfghjklasdfghjkl"
ac002_info="prod"

balance() {
    curl -X POST https://sms.yunpian.com/v1/user/get.json --data-urlencode "apikey=${!1}" 2>/dev/null | jq -r .user.balance
}

output () {
    echo "${!1} 剩餘 ${2}元"
}

for ac in $ac_list
do
    cash=$(balance ${ac})
    cash=${cash%.*}
    output ${ac}_info ${cash}

    if [ 100 -gt ${cash} ]; then
        curl -X POST \
            --data-urlencode "payload={\"username\":\"雲片(yunpian)\",\"text\": \"雲片($ac) -  該儲值囉!! 剩餘 ${cash}元.\"}" \
            https://hooks.slack.com/services/${slack} > /dev/null 2>&1
    fi

    curl -X POST \
        -H "Content-type":"application/json" \
        -d "{\"chat_type\":2,\"chat_id\":11574026,\"text\":\"雲片(${ac}) - 剩餘額度 ${cash}元 \"}" \
        https://api.rct2008.com:8443/10262144:NWQJUduLUVyM4Xq51Ae6InM3/sendTextMessage > /dev/null 2>&1
done