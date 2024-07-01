#!/bin/bash
set_title_row() {
    shift 1
    echo " $@ "
}

set_align_row() {
    
    case $1 in
        L|l)
            echo " :- "
            ;;
        M|m)
            echo " :-: "
            ;;
        R|r)
            echo " -: "
            ;;
        *)
            echo " - "
            ;;
    esac
}

set_info_row() {
    
    case $1 in
        L|l)
            shift 1

            url="(${1})"
            shift 1
            
            echo "[${@}]${url} "
            ;;
        S|s)
            shift 1
            echo " ${@} "
            ;;
        *)
            shift 1
            echo " - "
            ;;
    esac
}

table_info="${1}"
title_row="|" 
align_row="|"
line_count="0"

while read line
do
    line_count=$(( line_count + 1 ))

    if [ "${line}" == "" ]; then
        break
    fi

    title_row="${title_row}$(set_title_row ${line})|"
    align_row="${align_row}$(set_align_row ${line})|"

done < <(cat ${table_info})

echo ${title_row}
echo ${align_row}    

info_row="|"

while read line
do

    if [ "${line}" == "" ]; then
        continue
    elif [ "${line}" == "---" ]; then
        echo ${info_row}
        info_row="|"
        continue
    fi

    info_row="${info_row}$(set_info_row ${line})|"

done < <(tail -n +${line_count} ${table_info})
