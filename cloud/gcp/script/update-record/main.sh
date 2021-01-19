#!/bin/bash
set -xuo pipefail
WORKDIR="./ccdns"
PIDFILE="${WORKDIR}/pid"

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

FOLDERPATH=$(dirname $(readlink -f $0))
GCP_ZONE="${WORKDIR}/gcp.zone"
gcp=""

cp ${FOLDERPATH}/{gcp.zone} ${WORKDIR}

ts=$(date "+%Y%m%d%H")

for proj in $(cat ${FOLDERPATH}/project.list)
do

    gcp="${gcp}$(gcloud compute instances list --format="[no-heading](NAME,INTERNAL_IP)" --project ${proj} \
        | awk '!/gke/ {
            if ($2~"[0-9]+")
                n=split($2, ip, ",");
            else if ($2!~"[0-9]+")
                n="";
            for (i = 0; ++i <= n;)
                printf "%-40s        IN    A    %-15s\\n", $1, ip[i];
        }')"

    gcp="${gcp}$(gcloud sql instances list --format="[no-heading](NAME,PRIVATE_ADDRESS)" --project ${proj} \
        | awk '!/gke/ {
            printf "%-40s        IN    A    %-15s\\n", $1, $2;}' \
        | grep "^sit\|^prod"
        )"

    gcp="${gcp}$(gcloud redis instances list --region asia-east1 --format="[no-heading](INSTANCE_NAME,HOST)" --project ${proj} \
        | awk '!/gke/ {
            printf "%-40s        IN    A    %-15s\\n", $1, $2;}' \
        | grep "^sit\|^prod"
        )"
done

echo -e "\n${gcp}" >> ${GCP_ZONE}

sed -i "s/%%ts%%/$ts/" ${GCP_ZONE}

healthcheck() {
    if [ 0 -ne ${1} ]; then
        ./slack.sh -u CheckDomain \
            -c "operation-alert" \
            -T "Update dns record" \
            -s "error" \
            -p "Oops! OP" \
            -t "Google cloud dns update faile at ${2}."
    else
        rename zone zone.prev ${2}
    fi
}

gcloud dns record-sets import ${GCP_ZONE} \
    --zone gcp-domain-com-tw \
    --delete-all-existing \
    --replace-origin-ns \
    --zone-file-format \
    --project <project-id>
healthcheck ${?} ${GCP_ZONE}

rm ${WORKDIR}/pid