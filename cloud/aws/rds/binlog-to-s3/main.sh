#!/bin/bash
echo -e "\n[ $(TZ="Asia/Taipei" date +\"%Y%m%d-%H:%M:%S\") ] exec $0"

WORKSPACE="/opt/mysql-binlog"
PIDFILE="/tmp/${WORKSPACE##/*/}"

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

DB_HOST="127.0.0.1"
DB_PORT="3306"
DB_USER="USER_NAME"
DB_PASS="$(sudo cat /home/ubuntu/.pass.txt)"
CONNECT_ARG="--host=${DB_HOST} --port=${DB_PORT} --user=${DB_USER} --password=${DB_PASS}"

PREV_LAST_FILE="${WORKSPACE}/last"

set_file_str() {
    list=$(mysql ${CONNECT_ARG} -e "show binary logs;" 2> /dev/null | awk '{print $1}')

    if [ -f ${PREV_LAST_FILE} ]; then
        cur_file="$(cat ${PREV_LAST_FILE})"
        cur_file="${cur_file%.*}.$((10#${cur_file#*.} + 1 ))"
    else
        cur_file=$(echo -e "${list}" | head -2 | tail -1)
    fi

    last_file=$(echo -e "${list}" | tail -1)
}

flush_binlog() {
    mysql ${CONNECT_ARG} -e "FLUSH BINARY LOGS;"
    last_file="${last_file%.*}.$((10#${last_file#*.} + 1 ))"
}

pull_binlog() {
    mysqlbinlog  --read-from-remote-server ${CONNECT_ARG} \
        --result-file=${WORKSPACE}/binlog-to-cloudwatch \
        ${1}
}

push_s3() {
    aws s3 cp \
        ${WORKSPACE}/binlog-to-cloudwatch \
        s3://integrate-system-log/bin-log/${1} \
        --profile tw
}

set_file_str
flush_binlog

while [ ! "${cur_file}" = "${last_file}" ]
do
    pull_binlog "${cur_file}"

    echo "[ $(TZ=\"Asia/Taipei\" date +%y%m%d%H%M) ]" "${cur_file}" >> ${WORKSPACE}/download-history
    echo "${cur_file}" > ${PREV_LAST_FILE}

    push_s3 "${cur_file}"
    cur_file="${cur_file%.*}.$((10#${cur_file#*.} + 1 ))"
    sleep 120
done
