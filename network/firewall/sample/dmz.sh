##
# Reject direct flow into 192.168.200.0/24.
##
iptables -t mangle -A PREROUTING -i eth2 -d 192.168.200.0/24 -j DROP
iptables -t nat -A POSTROUTING -o eth2 -s 192.168.200.1 -d 192.168.20.0/24 -p tcp --dport 22 -j SNAT --to-source 192.168.77.1

###
# Admin manage line of major service.
###
iptables -t nat -A PREROUTING -i eth2 -s 192.168.100.77 -d 192.168.77.1 -j DNAT --to-destination 192.168.200.1

##
# Host
##
iptables -t nat -A PREROUTING -i eth2 -s 192.168.100.77 -d 192.168.77.14 -p tcp --dport 22 -j DNAT --to-destination 192.168.200.14

###
# VPN access
###
iptables -t nat -A POSTROUTING -o eth2 -s 192.168.200.2 -d 192.168.255.1/32 -p tcp --dport 443 -j SNAT --to-source 192.168.77.1
