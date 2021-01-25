#!/bin/bash
set -xuo pipefail
# Import configuration
. ./shell.conf

if [ ! -d ${WORKDIR} ]; then
    mkdir ${WORKDIR}
    if [ 0 -ne ${?} ]; then
        echo "Could not create workdir in ${WORKDIR}."
    fi
fi

if [ ! -f ${PIDFILE} ]; then
    echo $$ > ${PIDFILE}
    if [ 0 -ne ${?} ]; then
        echo "Could not write PID to ${PIDFILE}."
        exit 1
    fi
else
    ps -p $(cat ${PIDFILE}) > /dev/null 2>&1
    if [ 0 -eq ${?} ]; then
        echo "Shell script already in running."
        exit 1
    fi
    echo $$ > ${PIDFILE}
    if [ 0 -ne ${?} ]; then
        echo "Could not write PID to ${PIDFILE}."
        exit 1
    fi
fi

healthcheck() {
    if [ 0 -ne ${1} ]; then
        ./slack.sh -u CheckDomain \
            -c "operation-alert" \
            -T "Update dns record" \
            -s "error" \
            -p "Oops! OP" \
            -t "Google cloud dns update faile at ${2}."
    else
        rm ${2}.prev
        cp ${2} ${2}.prev
    fi
}

gcloud dns record-sets import ${GCP_ZONE} \
    --zone gcp-domain-com \
    --delete-all-existing \
    --replace-origin-ns \
    --zone-file-format \
    --project dabenxiang226
healthcheck ${?} ${GCP_ZONE}

rm ${PIDFILE}
