#!/bin/bash

FILE_PATH="./block.list"

head -n -2 blockips.conf \
	| awk '!/allow/{print $2}' > ${FILE_PATH}

tail -n 2 blockips.conf \
	| awk '!/allow/{print $2}' \
	| sed 's/;//g' >> ${FILE_PATH}

sed -i ':a;N;$!ba;s/;\n/,/g' ${FILE_PATH}

gcloud compute firewall-rules create test \
	--action deny \
	--source-ranges $(cat ${FILE_PATH}) \
	--rules all
