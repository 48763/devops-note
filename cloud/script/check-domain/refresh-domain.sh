#!/bin/bash
. module/aliyun.sh
. module/cert.sh
. ./conf

project() {

    find ../../project/$1 -type f \
        \( -name *prod.md -o -name *sit.md \) -exec cat {} \; \
        | grep -Po '(?<=^\| ).*?.com(?=.*? \|)' \
        | grep -Po '(?<=\.).*.com' \
        | sort -u   > list/domain.tmp 2> /dev/null

    if [ ! -s list/domain.tmp ]; then
        echo "Can't find file or directory."
        exit 1
    fi
}

ARG=$(echo $@ | sed 's/ /,/g')
if [ -1 -eq $(( $ARG )) ] || [ 0 -gt $(( $ARG )) ]; then
    echo "Number error."
    exit 1
elif [ 0 -lt $(( $ARG )) ]; then
    NUM=$ARG
    exit 0
else
    project $ARG
fi

while read output
do
    echo $output

    if [ 0 -ne $(cert_check_end project $output) ]; then
        code=$(cert_gen_ca project $output certonly)
        if [ 0 -ne $code ]; then
            echo "              Some challenges have failed."
        else
            echo "              Certonly Suceccful"
        fi
    fi

done < <(cat list/domain.tmp)