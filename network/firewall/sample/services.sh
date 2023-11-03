##
# Web
##
iptables -t nat -A PREROUTING -d 210.61.65.115 -p tcp --dport 80 -j DNAT --to 192.168.200.134:80
iptables -t nat -A PREROUTING -d 210.61.65.115 -p tcp --dport 443 -j DNAT --to 192.168.200.134:443

iptables -A FORWARD -i eth0 -d 192.168.200.134 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i eth0 -d 192.168.200.134 -p tcp --dport 443 -j ACCEPT

iptables -t nat -A POSTROUTING -o eth3 -s 192.168.0.0/16 -d 192.168.200.134 -p tcp --dport 80 -j SNAT --to-source 192.168.200.254
iptables -t nat -A POSTROUTING -o eth3 -s 192.168.0.0/16 -d 192.168.200.134 -p tcp --dport 443 -j SNAT --to-source 192.168.200.254
