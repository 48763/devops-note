#!/bin/sh
#set -x
echo `date +%Y%m%d%H%M`

find ../../project/* -type f \( -name *prod.md -o -name *sit.md \) -exec cat {} \; \
    | grep -P ^'(?<=\| )V(?= \|)' \
    | grep -Po '(?<=^\| ).*?.com(?=.*? \|)' \
    | grep -Po '(?<=\.).*.com' > list/icp.list
    
for dn in `cat ./list/icp.list ./list/new_icp \
	| grep -v "^#" \
    | sort -u \
	| awk '{print $1}'` 
do
    sleep 5
    
    echo "Check icp of $dn"

    ssh 47.106.216.138 -i ~/.ssh/mars -l root "
        curl -s -m 10 https://icp.chinaz.com/$dn -o res.txt
        err_code=\$?

        if [ 28 -eq \$err_code ]; then
            echo \"Operation timeout.\"
            exit 0
        elif [ 0 -ne \$err_code ]; then
            echo \"An unknown error.\"
            exit 0
        else
            cat res.txt | grep \"forbidden\" > /dev/null
            if [ 0 -eq \$? ]; then
                echo \"403 forbidden.\"
                exit 0
            fi
            
            cat res.txt | grep \"审核时间\" > /dev/null
            exit \$?
        fi
    "

    if [ 1 -eq $? ]; then
        echo $dn >> icp-req.txt
    fi

done

if [ -s icp-req.txt ]; then 
    package/slack.sh -u IcpCheck \
        -c alerting \
        -T "Check ICP" \
        -s "error" \
        -p "欸! OP" \
        -t "（測試開發腳本）以下 domain ICP 掉了 \n `cat icp-req.txt`"
    rm icp-req.txt
fi