#!/bin/bash
export TZ="Asia/Taipei"
echo ""
echo "#########################################"
echo "## Start: $(date) ##"
echo "#########################################"
echo ""

rsync --delete -avhP <src_path> <dest_path> > /dev/null
aws s3 sync <src_path> s3://<s3_name>/ --profile <profile_name> --delete

echo ""
echo "#########################################"
echo "##  End : $(date) ##"
echo "#########################################"
echo ""