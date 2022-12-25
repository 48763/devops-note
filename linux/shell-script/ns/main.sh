filter() {
    echo ${1} | grep ${2} &>/dev/null    
}

server() {

    ns=$(echo ${1} | grep -oE "[[:alnum:].]*\.[[:alpha:]]{1,}")

    if [ ! "$ns" ]; then
        continue
    fi
    output=$(nslookup -type=NS ${ns#*.})

    if filter "$output" nsone; then
        echo "${ns}: NS1"
    elif filter "$output" dnspod; then
        echo "${ns}: dnspod"
    else 
        echo ${output}
    fi
}

follower() {
    location=$(curl -Is https://${1} | grep -oE "[[:alnum:].]*\.[[:alpha:]]{1,}")
    if [ ! "${location}" ]; then
        echo ${1}
    else
        echo ${location}
    fi
}

nslook() { 
    ns=$(echo ${1} | grep -oE "[[:alnum:].]*\.[[:alpha:]]{1,}")
    if [ ! "${ns}" ]; then
        continue
    fi

    if [ "${L}" ]; then
        ns=$(follower ${ns})
    fi

    output=$(nslookup ${ns})
    
    if filter "$output" funnul; then
        js=$(echo ${js} | jq ".funnul += [\"${ns}\"]")
        cdn="funnul\n${cdn}"

    elif filter "$output" "site\|hkssm"; then
        js=$(echo ${js} | jq ".asia += [\"${ns}\"]")
        cdn="asia\n${cdn}"

    elif filter "$output" yunhucdn; then
        js=$(echo ${js} | jq ".vaicdn += [\"${ns}\"]")
        cdn="vaicdn\n${cdn}"

    else 
        echo ${output}
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
        nslook ${n}
    done

    for i in $(echo ${cdn} | sort -u)
    do
        echo "${i}: "
        echo ""
        echo ${js} | jq -r ".$i[]"
        echo " - - - "
    done
else
    for n in ${@} 
    do  
        server ${n}
    done
fi
