#!/bin/bash
file=$(ls *.conf)

match() {
    echo ${1} | grep "${2} " &> /dev/null
    if [ ${?} -eq 0 ]; then
        true
    else
        false
    fi
}

output() {

    while read -r line;
    do
        if [ "${line}" ]; then
            replace ${line}
        fi
    done < <(echo -e "${set_map}")

    for l in ${listen}
    do
        for p in ${proxy_pass}
        do

            for s in ${server_name}
            do

                nslookup ${s} &> /dev/null
                if [ ${?} -eq 0 ]; then
                    echo "${l} ${s} ${p}"
                else
                    echo "${l} ${s} ${p} dns_failed"
                fi
            done
        done
    done
}

replace() {
    proxy_pass=$(echo ${proxy_pass} | sed "s/${1}/${2}/g")
}

for f in ${file}
do 
    conf=$(grep "listen\|server_name\|proxy_pass\|set " ${f} | grep -v "#" | uniq)

    switch=0
    listen=""
    server_name=""
    proxy_pass=""
    set_map=""
    while read -r line;
    do
        
        if match "${line}" listen; then
            if [ ${switch} -eq 1 ]; then
                output
                server_name=""
                proxy_pass=""
                listen=""
                set_map=""
            fi
            listen="${listen} "$(echo ${line} | grep -Po "(?<=listen )[[:digit:]]*" )
            switch=0
            continue
        fi

        if match "${line}" server_name; then
            server_name="${server_name} "$(echo ${line} | grep -Po "(?<=server_name ).*(?=;)" )
            continue
        fi

        if match "${line}" set; then
            set_map="${set_map}"$(echo ${line} | grep -Po "(?<=set ).*(?=;)" )"\n"
            continue
        fi

        if match "${line}" proxy_pass; then
            switch=1
            proxy_pass="${proxy_pass} "$(echo ${line} | grep -Po "(?<=proxy_pass ).*(?=;)" )
            continue
        fi

    done < <(echo -e "${conf}")
    output
done
