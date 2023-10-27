#/bin/bash
AD=""
AE=""

alert_push() {

    if [ 0 -ne $(alert_exist) ]; then
        echo ""
    else
        package/slack.sh -u CheckDomain \
            -c "operation-alert" \
            -T "Check domain" \
            -s "error" \
            -p "欸! OP" \
            -t "Domain unhealthy\n $(cat alert.txt)"
        alert_rm
    fi
}

alert_exist() {
    if [ -f alert.txt ]; then
        echo 0
    else
        echo 1
    fi
}

alert_write() {
    if [ -n "$AE" ]; then
        printf "$AD" >> alert.txt
        printf "$AE" >> alert.txt
        AE=""
    fi

}

alert_rm() {
    rm alert.txt
}

alert_set_domain() {
    AD="$1 :\n"
}

alert_set_event() {
    AE="$AE         $1\n"
}
