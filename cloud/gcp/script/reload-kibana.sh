#!/bin/bash
PLUGIN_PATH="/usr/share/elasticsearch/bin/elasticsearch-plugin"
GCP_DOMAIN=".gcp.silkrode.com.tw"

echo > fail.txt
for proj in `gcloud projects list --format="[no-heading](PROJECT_ID)"`
do
	for pc in `gcloud compute instances list --format="[no-heading](NAME)" --filter="NAME:-es-" --project $proj`
	do
		echo "Try into $pc of $proj".
		
		ping -c 1 -w 1 $pc$GCP_DOMAIN > /dev/null 2>&1

		if [ $? -eq 0 ]; then
			ssh -t $pc$GCP_DOMAIN "
				echo \"Already on $pc.\"
				sudo systemctl daemon-reload;
				sudo systemctl restart elasticsearch > /dev/null 2>&1;
				if [ \$? -ne 0 ]; then
					echo $pc of $proj check elasticsearch restart fail.
				fi
			" >> fail.txt
			
			echo "done!"
		else 
			echo "$pc of $proj can't touch.". >> fail.txt
			echo "fail!"
		fi
	done
done