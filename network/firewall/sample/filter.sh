iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

##
# Allow specific remote host SSH to local
##
iptables -A INPUT -i eth3 -s 192.168.200.1 -p tcp --dport 22 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -o eth3 -p tcp --sport 22 -d 192.168.200.1 -j ACCEPT
