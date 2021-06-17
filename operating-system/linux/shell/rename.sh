#!/bin/bash

if [ -z ${1} ]; then
    echo error.
    exit 1 
fi

find ${1} ! -name README.md > output.temp

while read output
do
    tmp=$(echo ${output} | tr '[:upper:]' '[:lower:]' | sed 's/\ /-/g')

    if [ "${output##*/}" != "${tmp##*/}" ]; then
        mv "${tmp%/*}/${output##*/}" "${tmp}"
    fi

done < <(cat output.temp)

rm output.temp
