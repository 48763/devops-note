#!/bin/bash
PDJSON="{}"

pj_init() {
    pj_gen_domain_tmp

    pj_gen_domain_json
    pj_gen_domain_list

    pj_del_domain_tmp
}

pj_gen_domain_list() {
    cat list/project.tmp | sort -u > list/project.list
    rm -f list/project.tmp
}

pj_gen_domain_json() {

    while read output
    do
        local dn=$(echo $output \
            | grep -Po '(?<=^\| ).*?.com(?=.*? \|)' \
            | grep -Po '[[:alnum:]-]*?.com')

        echo $output | grep -P '(?<=\| )V(?= \|)' > /dev/null
        if [ 0 -eq $? ]; then
            pj_set_domain_json $dn 1
        elif [ null == $(pj_get_domain_json $dn) ]; then
            pj_set_domain_json $dn 0
        elif [ 1 -ne $(pj_get_domain_json $dn) ]; then
            pj_set_domain_json $dn 0
        fi
        
        echo $dn >> list/project.tmp

    done < <(cat list/filter.tmp)
}

pj_gen_domain_tmp() {
    find ../../project/* -type f \
        \( -name *prod.md -o -name *sit.md \) -exec cat {} \; \
        | grep -P '(?<=^\| ).*?.com(?=.*? \|)' > list/filter.tmp
}

pj_del_domain_tmp() {
    rm -f list/filter.tmp
}

pj_diff() {
    diff --unchanged-line-format="" \
        --old-line-format="- %L" \
        --new-line-format="+ %L" \
        list/project.list.prev list/project.list 
}

pj_archive_list() {
    mv list/project.list list/project.list.prev
}

pj_set_domain_json() {
    PDJSON=$(echo $PDJSON | jq ". += {\"$1\": \"$2\"}")
}

pj_get_domain_json() {
    echo $PDJSON | jq -r ".\"$1\""
}

pj_get_domain_num() {
    cat list/project.list | wc -l 
}

pj_print_list() {
    cat list/project.list
}

pj_print_json() {
    echo $PDJSON | jq .
}
