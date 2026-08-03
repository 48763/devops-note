#!/bin/bash
limit=${1}
shift 1
fail=0

for i in ${@}
do

    cnt=0
    while [ ${cnt} -lt ${limit} ]
    do
        
        sleep 3
        ./${i}

        if [ ${?} -eq 0 ]; then
            break
        fi

        cnt=$(( cnt + 1 ))
    done

    if [ ${cnt} -eq ${limit} ]; then
        fail=1
    fi
done

if [ ${fail} -ne 0 ]; then
    exit 1
fi
