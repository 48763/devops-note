#!/bin/bash
echo > fail.txt
for proj in `gcloud projects list --format="[no-heading](PROJECT_ID)"`
do
	for pc in `gcloud compute instances list --format="[no-heading](NAME)" --filter="NAME:-es-" --project $proj`
	do
		ping -c 1 prod-bms-es-tw-d01  > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			ssh -t ayang@prod-bms-es-tw-d01 "
				sudo systemctl daemon-reload;
				sudo systemctl restart elasticsearch > /dev/null 2>&1;
				if [ \$? -ne 0 ]; then
					echo $pc of $proj elasticsearch restart fail.
				fi
				sudo systemctl restart kibana" >> fail.txt
		fi
	done
done