#!/bin/bash
ADJSON="{}"

ali_init() {
    ali_gen_domain_tmp

    ali_gen_domain_json
    ali_gen_domain_list
    
    ali_del_domain_tmp
}

ali_gen_domain_list() {
    jq -r '.Data.Domain[] |  .DomainName' list/aliyun.tmp | sort -u > list/aliyun.list
}

ali_gen_domain_json() {
    ADJSON=$(jq '.Data.Domain | map( { (.DomainName): .DeadDateLong } ) | add' list/aliyun.tmp)
}

ali_get_domain_page_size() {
    aliyun domain QueryDomainList --PageNum 1 --PageSize 1 | jq -r .TotalItemNum
}

ali_gen_domain_tmp() {
    aliyun domain QueryDomainList --PageNum 1 --PageSize $(ali_get_domain_page_size) > list/aliyun.tmp
    if [ 0 -ne $? ]; then
        exit 1
    fi
}

ali_del_domain_tmp() {
    rm -f list/aliyun.tmp
}

ali_diff() {
    diff --unchanged-line-format="" \
        --old-line-format="- %L" \
        --new-line-format="+ %L" \
        list/aliyun.list.prev list/aliyun.list 
}

ali_archive_list() {
    mv list/aliyun.list list/aliyun.list.prev
}

ali_print_list() {
    cat list/aliyun.list
}

ali_print_json() {
    echo $ADJSON | jq .
}

ali_get_domain_num() {
    cat list/aliyun.list | wc -l 
}

ali_get_long_end_date() {
    echo $(ali_date_ms_to_s $(echo $ADJSON | jq -r .\"$1\"))
}

ali_date_ms_to_s() {
    echo $(( $1 / 1000 ))
}

ali_del_domain_json() {
    ADJSON=$(echo $ADJSON | jq "del(.\"$1\")")
}

ali_del_domain_list() {
    sed -i "/$1/d" list/aliyun.list
}

ali_add_dns() {
    echo "aliyun alidns AddDomainRecord --DomainName \$CERTBOT_DOMAIN  --RR \"_acme-challenge\" --Value \$CERTBOT_VALIDATION --Type TXT"
}

ali_del_dns() {
    echo "
        aliyun alidns DescribeDomainRecords --DomainName \$CERTBOT_DOMAIN \
        | jq '.DomainRecords.Record[] | select(.RR==\"_acme-challenge\") | .RecordId' -r \
        | while read domainId
        do
            aliyun alidns DeleteDomainRecord --RecordId \$domainId
        done
    "
}