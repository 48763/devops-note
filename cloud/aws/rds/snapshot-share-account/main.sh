#!/bin/bash
DAY=$(TZ="Asia/Taipei" date  +"%y%m%d%H")
SRC_ACCOUNT_ID="<ACCOUNT_ID>"
DEST_ACCOUNT_ID="<ACCOUNT_ID>"
REGION="<REGION_NAME>"
DB_NAME="<DATABASES_NAME>"
KMS="arn:aws:kms:ap-northeast-1:<SRC_ACCOUNT_ID>:key/<KMS_ID>"
WORKSPACE="/opt/rds-snapshot-cross-copy/"
PIDFILE="/tmp/rds-snapshot-cross-copy"

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

remove_pid_file() {
    rm ${PIDFILE}
}

check_cmd_status() {

    if [ 0 -ne ${?} ]; then
        remove_pid_file
        echo ${1} "failed. Check your status."
        exit 1
    fi
}

check_db_status() {

    aws rds describe-db-instances \
        --db-instance-identifier ${DB_NAME} \
        --region ${REGION} \
        --profile ${1} \
        | jq -r .DBInstances[0].DBInstanceStatus
}

check_snapshot_status() {

    aws rds describe-db-snapshots \
        --db-snapshot-identifier ${2} \
        --region ${REGION} \
        --profile ${1} \
        | jq -r .DBSnapshots[0].Status
}

create_snapshot() {

    if [ ! "$(check_db_status ${1})" == "available" ]; then
        remove_pid_file
        exit 1
    fi

    aws rds create-db-snapshot \
        --db-instance-identifier ${DB_NAME} \
        --db-snapshot-identifier mysql-${DAY}-encrypt \
        --region ${REGION} \
        --profile ${1} > /dev/null 2>&1

    check_cmd_status Create
    wait_snapshot ${1} mysql-${DAY}-encrypt
}

copy_snapshot() {

    aws rds copy-db-snapshot \
        --source-db-snapshot-identifier ${2} \
        --target-db-snapshot-identifier mysql-${DAY} \
        --kms-key-id ${KMS} \
        --region ${REGION} \
        --profile ${1} > /dev/null 2>&1

    check_cmd_status Copy
    wait_snapshot ${1} mysql-${DAY}
}

wait_snapshot() {

    while  [ ! "$(check_snapshot_status ${1} ${2})" == "available" ]
    do
        echo "Sleep 120s"
        sleep 120
    done
}

add_share_snapshot() {

    aws rds modify-db-snapshot-attribute \
        --db-snapshot-identifier mysql-${DAY} \
        --attribute-name restore \
        --values-to-add ${DEST_ACCOUNT_ID} \
        --region ${REGION} \
        --profile ${1} > /dev/null 2>&1
    
    check_cmd_status Share
}

delete_snapshot() {

    aws rds delete-db-snapshot \
        --db-snapshot-identifier ${2} \
        --region ${REGION} \
        --profile ${1} > /dev/null 2>&1

    check_cmd_status Delete
}

print_fmt() {
    printf "\n%s %s %s %s \n\n" "${DIVIDER}" "${1}" "${DIVIDER}"
}

print_fmt "${DAY}-Backup Start" 

print_fmt "SRC: Create Start"
create_snapshot src

print_fmt "SRC: Copy Start"
copy_snapshot src mysql-${DAY}-encrypt

print_fmt "SRC: Share Start"
add_share_snapshot src

print_fmt "DEST: Copy Start"
copy_snapshot dest arn:aws:rds:${REGION}:${SRC_ACCOUNT_ID}:snapshot:mysql-${DAY}

print_fmt "SRC: Clean up"
echo src mysql-${DAY}-encrypt >> ${WORKSPACE}snapshot.list

while read line
do
    delete_snapshot ${line}
    echo ${line} has been removed.
done < <(cat ${WORKSPACE}snapshot.list)


echo dest mysql-${DAY} > ${WORKSPACE}snapshot.list
echo src mysql-${DAY} >> ${WORKSPACE}snapshot.list
