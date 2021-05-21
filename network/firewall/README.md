# firewall


## iptables 語法

```bash
$ iptables [-t table] command [match] [-j target|jump]
# -t table = 規則表，預設為 filter
# command = 命令
# match = 比對
# -j target|jump = 目標
```

## iptables 相關

CentOS 服務預設：

```bash
$ service iptalbes start|stop|restart|save
# start|stop|restart = 啟動|暫停|重啟
# save = 儲存當前規則置規則表
```

CentOS 預設存放位置：

```
$ vi /etc/sysconfig/iptables
# 預設規則表位置
```