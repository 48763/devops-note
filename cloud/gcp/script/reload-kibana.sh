#!/bin/bash
PLUGIN_PATH="/usr/share/elasticsearch/bin/elasticsearch-plugin"
GCP_DOMAIN=".gcp.domain.com.tw"

echo "$(date)" > fail.txt

for proj in $(gcloud projects list --format="[no-heading](PROJECT_ID)")
do
    for vm in $(gcloud compute instances list --format="[no-heading](NAME)" --filter="NAME:-es-" --project ${proj})
    do
        echo "Try into ${vm} of ${proj}".
        
        nc -z -w 1 ${vm}${GCP_DOMAIN} 22 > /dev/null 2>&1

        if [ ${?} -eq 0 ]; then
            ssh -t ${vm}${GCP_DOMAIN} "
                echo \"  Already on ${vm}.\"
                sudo systemctl daemon-reload;
                sudo systemctl restart elasticsearch > /dev/null 2>&1;
                if [ \$? -ne 0 ]; then
                    echo \"  ${vm} of ${proj} check elasticsearch restart fail.\"
                else
                    echo \"  Success.\"
                fi
            " >> fail.txt
            
            echo "done!"
        else 
            echo "${vm} of ${proj} can't touch.". >> fail.txt
            echo "fail!"
        fi
    done
done