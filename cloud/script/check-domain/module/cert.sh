#!/bin/bash

cert_check_exist() {
    if [ -d cert/$1/$2 ]; then 
        echo 0
    else 
        echo 1
    fi
}

cert_gen_ca() {
    # e-mail to conf
    /opt/eff.org/certbot/venv/bin/letsencrypt $3 --manual \
        --agree-tos -d "*.$2" \
        -d "$2" --email itop@silkrode.com.tw \
        --preferred-challenges dns \
        --server https://acme-v02.api.letsencrypt.org/directory \
        --manual-public-ip-logging-ok \
        --config-dir .workspace/config \
        --work-dir .workspace/work \
        --logs-dir .workspace/logs \
        --manual-auth-hook="$(ali_add_dns)" \
        --manual-cleanup-hook="$(ali_del_dns)" > /dev/null 2>&1

    if [ 0 -ne $? ]; then
        echo 1
    else
        cert_mv_gen_ca $1 $2
        echo 0
    fi
}

cert_mv_gen_ca() {
    # path to conf
    if [ 0 -eq $(cert_check_exist $1 $2) ]; then
        cert_rm_ca $1 $2
    fi
    mv .workspace/config/archive/$2 cert/$1/
    rename.ul 1. . cert/$1/$2/*
}

cert_mv_ca() {
    if [ 0 -eq $(cert_check_exist $1 $2) ]; then
        mv cert/$1/$2 cert/$3/$2
    fi
}

cert_rm_ca() {
    if [ 0 -eq $(cert_check_exist $1 $2) ]; then
        rm -rf ./cert/$1/$2
    fi
}

cert_check_end() {
    # 2592000 to conf
    openssl x509 -checkend $cert_expire -noout -in cert/$1/$2/cert.pem > /dev/null
    echo $?
}