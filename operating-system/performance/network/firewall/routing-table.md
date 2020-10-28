

```bash
$ vi /etc/iproute2/rt_tables 

192     loki
```

```bash
ip rule add from 192.168.100.77/32 table loki
ip route add 210.61.65.0/24 dev eth0 table loki
ip route add 192.168.20.0/24 dev eth2 table loki
ip route add 192.168.255.0/24 dev eth2 table loki
ip route add 192.168.77.0/24 dev eth3 table loki
ip route add 192.168.200.0/24 dev eth3 table loki
ip route add default via 125.227.225.254 dev eth1 table loki
```