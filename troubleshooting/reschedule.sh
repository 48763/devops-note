#!/bin/sh

curl -s -k \
    -X GET \
    -H "Authorization: Basic YWRtaW46UEBzc3cwcmQ=" "https://10.205.35.192/nagios/cgi-bin/status.cgi?host=all&limit=0" \
    | grep -P "<td .* class='statusBG.*<\/tr>" \
    | grep -Po "(?<=\?).*(?='>)" > list

while read output
do
    echo $output | grep -Po "(?<=%2F%2F).*\.com"
    curl -s -k \
        -X POST \
        -H "Authorization: Basic YWRtaW46UEBzc3cwcmQ=" \
        --data "cmd_typ=7&cmd_mod=2&$output&start_time=09-23-2020+18:23:50&force_check=on&btnSubmit=Commit" \
        "https://10.205.35.192/nagios/cgi-bin/cmd.cgi?cmd_typ=7&$output&force_check" \
    | grep -Po "(?<='>).*(?=<BR><BR>)" \
    && echo 
done < list
