PATH=${PATH}:/usr/sbin/
###
# Allow all
###
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

###
# Initial policy
###
iptables -F -t mangle
iptables -X -t mangle
iptables -Z -t mangle
iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat
iptables -F 
iptables -X
iptables -Z

###
# Self
###
sh filter.sh

###
# NAT
###
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth2 -s 192.168.0.0/24 -j ACCEPT
iptables -A FORWARD -i eth2 -s 192.168.100.0/24 -j ACCEPT
iptables -A FORWARD -i eth3 -s 192.168.200.0/24 -j ACCEPT

sh dmz.sh
sh services.sh

###
# Log
###
# iptables -N FLOG 
# iptables -A FLOG -j LOG --log-level 7 --log-prefix [FILTER]
# iptables -A FLOG -j ACCEPT


## #
# Set policies
###
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
