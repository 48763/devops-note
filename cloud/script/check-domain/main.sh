#!/bin/bash
#set -x
## import module
. module/aliyun.sh
. module/project.sh
. module/cert.sh
. module/icp.sh
. module/doc.sh
. module/alert.sh
. ./conf

## init main object
ali_init
pj_init

# Project

## prepare
doc_set list project.md
doc_printf "# Project\n\n"

echo "Diff domain:"
doc_printf "## Diff \n\n"
doc_printf "\`\`\`\n"

while read output
do
    echo "              $output"
    doc_printf "              $output\n"

    echo $output | grep "^+" > /dev/null
    if [ 0 -eq $? ]; then
        cert_mv_ca aliyun $(echo $output | sed 's/..//') project
    else
        cert_mv_ca project $(echo $output | sed 's/..//') aliyun
    fi

done < <(pj_diff)

doc_printf "\`\`\`\n\n"
echo && sleep 3

## iterate domain in project.
doc_printf "## Status\n\n"
doc_printf "| Domain | End Date | Certificate | ICP |\n"
doc_printf "| :- | -: | -: | -: |\n"

while read output
do

    echo "Check domain: $output"
    doc_printf "| $output "
    alert_set_domain $output

    ## date
    echo "- Stage date :"

    # Can be moudle.
    aging=$(( $(ali_get_long_end_date $output) - $(date +%s)  ))

    if [ $aging -lt 0 ]; then
        echo "              EXPIRE"
        doc_printf "| \`EXPIRE\` "
    elif [ $aging -lt $domain_expire ]; then
        echo "              $output will expire in $(( $aging / 84600 )) days."
        doc_printf "| \`$(( $aging / 84600 ))\` "
        alert_set_event "域名剩餘 $(( $aging / 84600 ))天到期！"
    else
        echo "              HEALTH"
        doc_printf "| HEALTH "
    fi

    # push alert stack

    ## cert
    echo "- Stage cert :"

    # Q: 過期域名處理。
    # generate can be check and retry
    if [ 0 -gt $aging ]; then
        echo "              FAILED"
        doc_printf "| \`FAILED\` "
    elif [ 0 -ne $(cert_check_exist project $output) ]; then
        code=$(cert_gen_ca project $output certonly)
        if [ 0 -ne $code ]; then
            echo "              Some challenges have failed."
            doc_printf "| \`FAILED\` "
            alert_set_event "憑證申請失敗！"
        else
            echo "              Certonly Suceccful"
            doc_printf "| CERTONLY "
        fi
    elif [ 0 -ne $(cert_check_end project $output) ]; then
        code=$(cert_gen_ca project $output certonly)
        if [ 0 -ne $code ]; then
            echo "              Some challenges have failed."
            doc_printf "| \`FAILED\` "
            alert_set_event "憑證更新失敗！"
        else
            echo "              Renew Suceccful"
            doc_printf "| RENEW "
            alert_set_event "憑證更新成功！請務必更換環境憑證！"
        fi
    else
        echo "              HEALTH"
        doc_printf "| HEALTH "
    fi

    # push alert stack

    ## icp
    echo "- Stage icp :"

    if [ 1 -eq $(pj_get_domain_json $output) ]; then
        code=$(icp_check $output)
        if [ 0 -ne $code ]; then
            echo "              $code"
            doc_printf "| \`$code\` "
            alert_set_event "ICP 錯誤代碼：$code"
        else
            echo "              HEALTH"
            doc_printf "| HEALTH "
        fi
    else
        echo "              -"
        doc_printf "| - "
    fi

    #   push alert stack

    ali_del_domain_list $output
    doc_printf "|\n"
    alert_write
    echo && sleep 0
done < <(pj_print_list)

alert_push
pj_archive_list

# Aliyun

## prepare
doc_set list aliyun.md
doc_printf "# Aliyun\n\n"

echo "Diff domain:"
doc_printf "## Diff \n\n"
doc_printf "\`\`\`\n"

while read output
do
    echo "              $output"
    doc_printf "              $output\n"

    echo $output | grep "^-" > /dev/null
    if [ 0 -eq $? ]; then
        cert_rm_ca aliyun $(echo $output | sed 's/..//')
    fi

done < <(ali_diff)

doc_printf "\`\`\`\n\n"
echo && sleep 3

## iterate domain name in aliyun.
doc_printf "## Status\n\n"
doc_printf "| Domain | End Date | Certificate | ICP |\n"
doc_printf "| :- | -: | -: | -: |\n"

while read output
do

    echo "Check domain: $output"
    doc_printf "| $output "
    alert_set_domain $output

    ## date
    echo "- Stage date :"

    # Can be moudle.
    aging=$(( $(ali_get_long_end_date $output) - $(date +%s)  ))

    if [ $aging -lt 0 ]; then
        echo "              EXPIRE"
        doc_printf "| \`EXPIRE\` "
    elif [ $aging -lt $domain_expire ]; then
        echo "              $output will expire in $(( $aging / 84600 )) days."
        doc_printf "| \`$(( $aging / 84600 ))\` "
        alert_set_event "域名剩餘 $(( $aging / 84600 ))天到期！"
    else 
        echo "              HEALTH"
        doc_printf "| HEALTH "
    fi

    # push alert stack

    ## cert
    echo "- Stage cert :"

    # Q: 過期域名處理。
    # generate can be check and retry

    if [ $aging -lt 0 ]; then
        echo "              FAILED"
        doc_printf "| \`FAILED\` "
    elif [ 0 -ne $(cert_check_exist aliyun $output) ]; then
        code=$(cert_gen_ca aliyun $output certonly)
        if [ 0 -ne $code ]; then
            echo "              Some challenges have failed."
            doc_printf "| \`FAILED\` "
        else
            echo "              Certonly Suceccful"
            doc_printf "| CERTONLY "
        fi
    elif [ 0 -ne $(cert_check_end aliyun $output) ]; then
        code=$(cert_gen_ca aliyun $output certonly)
        if [ 0 -ne $code ]; then
            echo "              Some challenges have failed."
            doc_printf "| \`FAILED\` "
        else
            echo "              Renew Suceccful"
            doc_printf "| RENEW "
        fi
    else
        echo "              HEALTH"
        doc_printf "| HEALTH "
    fi

    doc_printf "| - |\n"
    alert_write
    echo && sleep 0
done < <(ali_print_list)

alert_push
ali_archive_list

# slack push alert
