# Target

篩選過後的串流封包，將會按照 Target 規則進行動作。

### ACCEPT

篩選出來後，同意(允許)封包通過

```bash
[root@localhost ~]# iptables -A INPUT -p tcp --dport 80 -j ACCEPT -v
ACCEPT  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:80 
```

### DROP

篩選出來後，丟棄封包

```bash
[root@localhost ~]# iptables -A INPUT -p tcp --dport 1024:65535  -j DROP -v 
DROP  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpts:1024:65535
```

### RETURN

```bash
[root@localhost ~]# iptables -A INPUT -p tcp --dport 53 -j Test -v
Test  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:53 
[root@localhost ~]# iptables -A INPUT -p tcp --dport 53 -j RETURN -v
RETURN  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:53 
```

### QUEUE

篩選出來後，將封包重導至佇列中

```bash
[root@localhost ~]# iptables -A OUTPUT -p icmp -j QUEUE -v
QUEUE  icmp opt -- in * out *  0.0.0.0/0  -> 0.0.
```
