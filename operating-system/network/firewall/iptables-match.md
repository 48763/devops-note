# Match

會按照條件篩選串流封包，如果在選項前加入 `!`，則為相反（否定）

```bash
$ iptables -A OUTPUT -o eth0 -p tcp ! -s 192.168.0.0/24 -j ACCEPT -v
ACCEPT  tcp opt -- in * out eth0 !192.168.0.0/24  -> 0.0.0.0/0 
```

### -v 或 --verbose

輸出詳細資訊(verbose mode)

```bash
$ iptables -A INPUT -p tcp --dport 80 -j ACCEPT -v
ACCEPT  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:80 
# -v = --verbose
# -v 可用於：list, append, insert, delete, replace
# 如果輸出規則清單時(iptables -L -v)
# 計數器會以 K, M, G 代替 1,000、1,000,000、1,000,000,000
```

### --line-numbers

輸出規則清單時，加入行號(print line numbers when listing)

```bash
$ iptables -L INPUT -v --line-number
Chain INPUT (policy ACCEPT 312 packets, 13338 bytes)
num   pkts bytes target     prot opt in     out     source               destination         
1     4183  211K            all  --  any    any     anywhere             anywhere            
2     1054 75568 ACCEPT     tcp  --  any    any     anywhere             anywhere            tcp dpt:ssh 
3        0     0 DROP       tcp  --  any    any     anywhere             anywhere            tcp dpt:http 
4    10000 1000K ACCEPT     tcp  --  any    any     anywhere             anywhere            tcp dpt:https 
```

### -n 或 --numeric

輸出詳細規則清單時，將位址和埠數值化(numeric output of addresses and ports)

```bash
$ iptables -L INPUT -v -n
# -n = --numeric
# 可比對 --line-number 的輸出範例有何不同
Chain INPUT (policy ACCEPT 920 packets, 39660 bytes)
 pkts bytes target     prot opt in     out     source               destination         
 3884  197K            all  --  *      *       0.0.0.0/0            0.0.0.0/0           
  561 40212 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:22 
    0     0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:80
10000 1000K ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:443 
```

### -x 或 --exact

輸出詳細規則清單時，將計數器數值精準輸出(expand numbers (display exact valu</p>

```bash
$ iptables -L INPUT -v -n -x
# x = --exact
Chain INPUT (policy ACCEPT 1565 packets, 67737 bytes)
    pkts      bytes target     prot opt in     out     source               destination         
    5706   284613            all  --  *      *       0.0.0.0/0            0.0.0.0/0           
    1324    94344 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:22 
       0        0 DROP       tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:80 
   10000  1000000 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:443
# 可比對 -v 的輸出範例，在計數器的部分有何不同
```

### -c 或 --set-counters

在新增或插入規則時，設定計數器(set the counter during insert/append)

```bash
$ iptables -R INPUT 4 -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT -c 100 500
# -c = --set-counters
# --set-counters PKTS BYTES
# 4 = 預設 iptables 的 INPUT 鏈規則中，第四行為：
# -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
$ iptables -L INPUT -v
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
  669 47852 ACCEPT     all  --  any    any     anywhere             anywhere            state RELATED,ESTABLISHED 
    0     0 ACCEPT     icmp --  any    any     anywhere             anywhere            
    0     0 ACCEPT     all  --  lo     any     anywhere             anywhere            
  100   500 ACCEPT     tcp  --  any    any     anywhere             anywhere            state NEW tcp dpt:ssh 
    0     0 REJECT     all  --  any    any     anywhere             anywhere            reject-with icmp-host-prohibited 
# 本範例與其它範例在不同環境下使用
# 故內容並不相同
```

### -i 或 --in-interface

設定規則入方向所比對的網路介面卡名稱(network interface name ([+] for wildca</p>

```bash
$ iptables -A INPUT -i eth0 -p tcp --dport 3306 -j ACCEPT -v
# -i = --in-interface
# eth0 = 網卡名稱
# 如設定 eth+ 為比對大範圍
ACCEPT  tcp opt -- in eth0 out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:3306 
```

### -o 或 --out-interface

設定規則出方向所比對的網路介面卡名稱(network interface name ([+] for wildca</p>

```bash
$ iptables -A OUTPUT -o eth+ -p tcp --dport 80 -j ACCEPT -v
# -o = --out-interface
# eth0 = 網卡名稱
# 沒指定網卡時，表示使用所有介面卡
ACCEPT  tcp opt -- in * out eth+  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:80 
```

### -p 或 --proto

設定規則所比對的協定(protocol: by number or name, eg. `tcp')

```bash
$ iptables -A INPUT -p 6 --dport 3128 -j ACCEPT -v
# -p = --proto
# 6 = tcp
# 協定編號路徑：/etc/protocol
# -p 亦可指定協定名稱
ACCEPT  tcp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  tcp dpt:3128 
```

### -d 或 --destination(dst)

設定規則比對的目的地位址(destination specification)

```bash
$ iptables -A OUTPUT -d 192.168.0.0/24 -j ACCEPT
# -d = --destination
# -d address[/mask][...]
# 192.168.0.0/24 = 指定一網段，也可指定單一 位址(Address) 或 網域(domain)
ACCEPT  all opt -- in * out *  0.0.0.0/0  -> 192.168.0.0/24
```

### -s 或 --source

設定規則比對的來源位址(source specification)

```bash
$ iptables -A INPUT -s google.com -j ACCEPT -v
# -s = --source
# -s address[/mask][...]
# google.com = 指定一網段，也可指定單一 位址(Address) 或 網域(domain)
ACCEPT  all opt -- in * out *  64.233.188.102  -> 0.0.0.0/0  
ACCEPT  all opt -- in * out *  64.233.188.101  -> 0.0.0.0/0  
ACCEPT  all opt -- in * out *  64.233.188.138  -> 0.0.0.0/0  
ACCEPT  all opt -- in * out *  64.233.188.100  -> 0.0.0.0/0  
ACCEPT  all opt -- in * out *  64.233.188.139  -> 0.0.0.0/0  
ACCEPT  all opt -- in * out *  64.233.188.113  -> 0.0.0.0/0 
```

### -f 或 --fragment

設定規則比對第二或後續片段封包的方式(match second or further fragments only)

```bash
$ iptables -A OUTPUT -f -d 192.168.1.1 -j DROP -v
# -f = --fragment
# 片段
DROP  all opt -f in * out *  0.0.0.0/0  -> 192.168.1.1  
```

### -j 或 --jump

設定規則在比對完畢後的目標(target for rule (may load target extension))

```bash
$ iptables -A INPUT -p icmp -j DROP -v
# -j = --jump
DROP  icmp opt -- in * out *  0.0.0.0/0  -> 0.0.0.0/0  
```

### --modprobe

設定規則在比對時使用模組(try to insert modules using this command)

```bash
$ iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE --modprobe=/sbin/modprobe -v
MASQUERADE  all opt -- in * out ppp0  0.0.0.0/0  -> 0.0.0.0/0  
```