#!/bin/bash

icp_check() {
    curl -s -m 10 https://icp.chinaz.com/$1 -o res.txt
    err_code=$?
    
    if [ 0 -ne $err_code ]; then
        echo $err_code
    else
        cat res.txt | grep "forbidden" > /dev/null
        if [ 0 -eq $? ]; then
            echo "403"
        fi

        cat res.txt | grep "审核时间" > /dev/null
        echo $?
    fi

    rm res.txt
}
