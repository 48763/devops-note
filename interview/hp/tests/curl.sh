#!/bin/bash

curl localhost:8080/ > /dev/null 2>&1
if [ ! ${?} -eq 0 ]; then
    echo "Something error."
    exit 1;
fi
