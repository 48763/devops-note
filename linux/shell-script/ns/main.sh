#!/bin/sh
filter() {
    echo ${1} | grep ${2} &>/dev/null    
}

regular() {
    echo -e "${1}" | grep -oE "[[:alnum:].]*\.[[:alpha:]]{1,}"
}

get_ns_server() {
    ns=$(regular ${1})
    if [ ! "$ns" ]; then
        continue
    fi

    ns=$(get_host ${ns} | grep -oE "[[:alnum:]]*\.[[:alpha:]]{1,}$")

    output=$(nslookup -type=NS ${ns})

    if filter "$output" nsone; then
        echo "${ns}: NS1"
    elif filter "$output" dnspod; then
        echo "${ns}: dnspod"
    else 
        echo -e "${ns}: ${output}"
    fi
}

get_host() {
    location=$(curl -Is https://${1} | grep location | grep -oE "[[:alnum:].]*\.[[:alpha:]]{1,}")

    if [ ! "${L}" ];then
        echo ${1}
    elif [ "${location}" ]; then
        echo ${location}
    else
        echo ${1}
    fi
}

get_domain() { 
    ns=$(regular ${1})
    if [ ! "${ns}" ]; then
        continue
    fi

    ns=$(get_host ${ns})

    output=$(nslookup ${ns} 2>&1)
    
    if filter "$output" funnul; then
        js=$(echo ${js} | jq ".funnul += [\"${ns}\"]")
        cdn="funnul\n${cdn}"

    elif filter "$output" site; then
        js=$(echo ${js} | jq ".asia += [\"${ns}\"]")
        cdn="asia\n${cdn}"

    elif filter "$output" "yunhucdn\|hkssm"; then
        js=$(echo ${js} | jq ".vaicdn += [\"${ns}\"]")
        cdn="vaicdn\n${cdn}"

    else 
        echo -e "${output}"
    fi
}

for i in ${@}
do
    case ${i} in 
        -L)
            L="1"
        ;;
        -N)
            N="1"
        ;;
    esac
done


if [ ! "${N}" ]; then
    cdn=""
    js={}
    for n in ${@} 
    do  
        get_domain ${n}
    done

    echo ""
    for i in $(echo -e "${cdn}" | sort -u)
    do
        echo "- ${i}: "
        echo ""
        echo ${js} | jq -r ".$i[]"
        echo ""
    done
else
    for n in ${@} 
    do  
        get_ns_server ${n}
    done
fi
