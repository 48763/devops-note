# TCP 內核參數調優

## 修改參數

暫時調整：

```
$ sysctl -w net.core.somaxconn=4096
```

永久調整

```
$ vi /etc/sysctl.conf
net.core.somaxconn=4096
```


## net.ipv4.tcp_abort_on_overflow

設定 `1` 啟用時，當 tcp 隊列滿載時，將會中斷連線。
