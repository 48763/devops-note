#!/bin/bash
filter() {
    # text com-key-word
    echo -e "${1}" | grep "${2}" &>/dev/null    
}

dm_regular() {
    # text
    echo -e "${1}" | grep -oE "[[:alnum:].-]*\.[[:alpha:]]{1,}"
}

ip_regular() {
    # text
    echo -e "${1}" \
    | grep -v "Server\|#53\|:53" \
    | grep -oE "[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*"
    echo ""
}

get_host() {
    location=$(curl -Is -m 5 http://${1} | grep ^location | grep -oE "[[:alnum:].]*\.[[:alpha:]]{1,}")

    if [ "${L}" ] && [ "${location}" ]; then
        echo ${location}
    elif [ "${type}" ]; then
        echo ${1} | grep -oE "[[:alnum:]]*\.[[:alpha:]]{1,}$"
    else
        echo ${1}
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

    if filter "${1}" funnul; then
        js=$(echo ${js} | jq ".funnul += [\"${2}\"]")
        com="funnul\n${com}"
    elif filter "${1}" site-; then
        js=$(echo ${js} | jq ".asia.\"$(get_cname "${1}")\" += [\"${2}\"]")
        com="asia\n${com}"
    elif filter "${1}" "yunhucdn\|hkssm\|hkcmm"; then
        js=$(echo ${js} | jq ".vaicdn += [\"${2}\"]")
        com="vaicdn\n${com}"
    elif filter "${1}" "hknui"; then
        js=$(echo ${js} | jq ".korims += [\"${2}\"]")
        com="korims\n${com}"
    elif filter "${1}" "pscddos"; then
        js=$(echo ${js} | jq ".polar += [\"${2}\"]")
        com="polar\n${com}"
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
        ip_regular "${output}"
    fi
}

get_record_address() { 
    dm=$(dm_regular ${1})
    if [ ! "${dm}" ]; then
        continue
    fi

    dm=$(get_host ${dm})
    
    output=$(ns_cmd ${dm})

    class "${output}" ${dm}
}

while [ ${#} -gt 0 ]
do
    case ${1} in 
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
    echo ${js} | jq -r ".$i"
    echo ""
done
