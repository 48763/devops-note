#!/bin/bash
filter() {
    # text com-key-word
    echo -e "${1}" | grep "${2}" &>/dev/null    
}

dm_regular() {
    # text
    echo -e "${1}" | grep -oE "[[:alnum:].-]*\.[[:alpha:]]{1,}[\:[:digit:]]*"
}

record_regular() {
    # text

    if [ ns == "${type}" ]; then
        echo -e "${1}" \
        | grep -o "nameserver.*" \
        | grep -Eo "[[:alnum:].-]*\.[[:alpha:]]{1,}[\:[:digit:]]*"
        echo ""
    else
        echo -e "${1}" \
        | grep -v "Server\|#53\|:53" \
        | grep -oE "[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*"
        echo ""
    fi
}

get_host() {
    location=""
    
    if [ "${L}" ]; then
        location=$(curl -Is -m 3 http://${1} | grep "^location\|^Location" | grep -oE "[[:alnum:].]*\.[[:alpha:]]{1,}")
    fi

    if [ ns == "${type}" ]; then
        echo ${location:=${1%:*}} | grep -oE "[[:alnum:]]*\.[[:alpha:]]{1,}$"
    else
        echo ${location:=${1%:*}}
    fi
}

ns_cmd() {
    nslookup $([ ! ${type} ] || echo -type=${type}) ${1} $([ ! ${dns} ] || echo ${dns}) 2>&1
}

get_cname() {
    cname=$(echo "${1}" | grep canonical | head -1)
    echo "${cname#*= }"
}

class() {

    if filter "${1}" site-; then
        js=$(echo ${js} | jq ".asia.\"$(get_cname "${1}")\" += [\"${2}\"]")
        com="asia\n${com}"
    elif filter "${1}" "yunhucdn\|hkssm\|hkcmm"; then
        js=$(echo ${js} | jq ".vaicdn += [\"${2}\"]")
        com="vaicdn\n${com}"
    elif filter "${1}" nsone; then
        js=$(echo ${js} | jq ".ns1 += [\"${2}\"]")
        com="ns1\n${com}"
    elif filter "${1}" dnspod; then
        js=$(echo ${js} | jq ".dnspod += [\"${2}\"]")
        com="dnspod\n${com}"
    elif filter "${1}" cloudflare; then
        js=$(echo ${js} | jq ".cloudflare += [\"${2}\"]")
        com="cloudflare\n${com}"
    elif filter "${1}" "No answer"; then
        js=$(echo ${js} | jq ".no_answer += [\"${2}\"]")
        com="no_answer\n${com}"
    elif filter "${1}" "NXDOMAIN"; then
        js=$(echo ${js} | jq ".non_existent += [\"${2}\"]")
        com="non_existent\n${com}"
    else
        echo -e "- ${2}: \n"
        record_regular "${1}"
    fi
}

get_record_address() { 
    dm=$(dm_regular ${1})
    if [ ! "${dm}" ]; then
        continue
    fi

    location=$(get_host ${dm})
    dns_output=$(ns_cmd ${location})

    if [ "${L}" ] && [ ! "${dm}" = "${location}" ] ; then
        class "${dns_output}" "${dm} => ${location}"
    else
        class "${dns_output}" "${location}"
    fi

}

while [ ${#} -gt 0 ]
do
    case ${1} in 
        -d|-D)
            d="1"
        ;;
        -L)
            L="1"
        ;;
        -n)
            dns="${2}"
            shift 1
        ;;
        -t)
            type="${2}"
            shift 1
        ;;
        *)
            domains="${1} ${domains}"
        ;;
    esac

    shift 1
done

if [ "${d}" ]; then
    set -x
fi

com=""
js={}

for dm in ${domains} 
do  
    get_record_address ${dm}
done

echo ""
for i in $(echo -e "${com}" | sort -u)
do
    echo "- ${i}: "
    echo ""

    keys=$(echo ${js} | jq -r ".$i | keys[]")
    if [ "0" == ${keys:0:1} ]; then
        echo ${js} | jq -r ".$i[]"
    else
        for k in ${keys}
        do
            echo "-- ${k%\.}: "
            echo ""
            echo ${js} | jq -r ".$i.\"$k\"[]"
            echo ""
        done
    fi
    echo ""
done
