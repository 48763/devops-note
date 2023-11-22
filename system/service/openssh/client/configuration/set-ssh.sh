#!/bin/bash

##
# Help
##

if [ -z $3 ];
    then
	echo ""
    echo "Usage: set-ssh directory hoatname address"
	echo ""
	echo "Argument:"
	echo ""
	echo "	Directory value is [main|dev|test]."
	echo "	Hostname is for ssh when connect remote host."
	echo "	Address is ip-address of target host."
    exit 1
fi

##
# Generate configuration
##
ssh-keygen -t rsa -b 4096 -f key/$1/$2 -q -N ""

echo "Host $2" >> config

echo "
Host $2
	HostName $3
	User root
	IdentityFile ~/.ssh/key/$1/$2" >> conf.d/$1.conf

##
# SSH_ENV
##
export DISPLAY=:0
export SSH_ASKPASS=/tmp/ssh_askpass

read -ers -p "Please input your target host password: " PASSWD
echo ""
echo "echo $PASSWD" > $SSH_ASKPASS
chmod +x $SSH_ASKPASS

##
# Host configure ssh key
##
setsid ssh-copy-id -f -i ~/.ssh/key/$1/$2 beladmin@$3
rm $SSH_ASKPASS

##
# Configure ssh service configuration file.
##

ssh -t $2 "echo '$PASSWD' | sudo -S su -c \"echo \\\"Match User beladmin
	PasswordAuthentication no
	PubkeyAuthentication yes\\\" | tee --append /etc/ssh/sshd_config;
	service ssh restart\""
