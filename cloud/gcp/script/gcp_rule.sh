#!/bin/sh
set -x

FILE=block.tmp

echo $FILE

head -n -2 blockips.conf \
	| awk '!/allow/{print $2}' > $FILE

tail -n 2 blockips.conf \
	| awk '!/allow/{print $2}' \
	| sed 's/;//g' >> $FILE

sed -i ':a;N;$!ba;s/;\n/,/g' $FILE

gcloud compute firewall-rules create test --action deny --source-ranges $(cat $FILE) --rules al
