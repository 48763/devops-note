#!/bin/sh
set -xuo pipefail

FILE_PATH=$(dirname $(readlink -f $0))
# new
GCP_ZONE=/tmp/GCP.zone

ts=`date "+%Y%m%d%H"`

cat <<EOF > $GCP_ZONE
\$TTL 300
@ IN SOA ns-cloud-d1.googledomains.com. hostmaster.yukifans.com. ( 
		$ts			; Serial
		10800		; Refresh
		3600		; Retry
		604800		; Expire
		38400 )		; Negative Cache TTL

	IN		NS		ns-cloud-d3.googledomains.com.
	IN		NS		ns-cloud-d4.googledomains.com.
	IN		NS		ns-cloud-d2.googledomains.com.
	IN		NS		ns-cloud-d1.googledomains.com.

EOF

cat ${FILE_PATH}/gcp.zone > $GCP_ZONE

for proj in `gcloud projects list --format="[no-heading](PROJECT_ID)"`
do
	gcloud compute instances list --format="[no-heading](NAME,INTERNAL_IP)" --project $proj \
		| awk '!/gke/ {
			if ($2~"[0-9]+")
				n=split($2, ip, ",");
			else if ($2!~"[0-9]+") 
				n="";
			for (i = 0; ++i <= n;)
				print $1." IN A ",ip[i];}' | grep '^sit\|^prod' >> $GCP_ZONE

	gcloud sql instances list --format="[no-heading](NAME,PRIVATE_ADDRESS)" --project $proj \
		| awk ' {
			print $1." IN A ", $2;}' | grep '^sit\|^prod' >> $GCP_ZONE

	gcloud redis instances list --region asia-east1 --format="[no-heading](INSTANCE_NAME,HOST)" --project $proj \
		| awk ' {
			print $1." IN A ", $2;}' | grep '^sit\|^prod' >> $GCP_ZONE
done

gcloud dns record-sets import $GCP_ZONE \
	--zone gcp-silkrode-com-tw \
	--delete-all-existing \
	--replace-origin-ns \
	--zone-file-format
