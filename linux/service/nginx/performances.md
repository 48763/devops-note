# Performance Tuning

## Note

- worker
    - num
    - connections
- reuseport
- backlog
- openfile
- keepalive
- log buffer
- timeout
    - FIN - ACK
    - nginx
- ssl_cipher
- data expire
- limit connections

## Open File

```
$ ulimit -n
```

```
$ cat /proc/4673/limits
$ vi /lib/systemd/system/nginx.service
```

```
worker_processes = Number of CPUs ($ grep -c processor /proc/cpuinfo)
worker_rlimit_nofile = ( RLIMIT_NOFILE / worker_processes ) - 1024  
```

> NOFILE = number of open files

## backlog 

`backlog` 是限制 TCP 全連接佇列的數值，其預設值為 `511`。

```
$ ss -ltn
State        Recv-Q       Send-Q               Local Address:Port                Peer Address:Port       Process
LISTEN       0            511                        0.0.0.0:80                     0.0.0.0:*
```

但該數值是與 `net.core.somaxconn` 有所關聯，是取兩數值的最小值：

```
$ sysctl -a | grep net.core.somaxconn
net.core.somaxconn = 4096
```

>  Since Linux 5.4 it was increased to 4096.

> 從上面兩個指令輸出，即可以判斷該 nginx 的配置為預設。而較舊的系統中， `net.core.somaxconn = 128`，此時 `ss` 就會看到 `Send-Q` 為 `128`。

> Old versions of Linux kernel have nasty bug of truncating somaxcon value to it's 16 lower bits (i.e. casting value to uint16_t), so raising that value to more than 65535 can even be dangerous. 

當全連接調整完後，就要考慮半連結是否足夠：

```
$ sysctl -a | grep tcp_max_syn_backlog
net.ipv4.tcp_max_syn_backlog = 4096
```

> 如果有啟用 `tcp_syncookies`，可以忽略半連接設置。


```
$ ss -at | grep  SYN-RECV
```


```
$ sysctl -a | grep net.ipv4.tcp_abort_on_overflow
```


暫時調整：

```
$ sysctl -w net.core.somaxconn=4096
```

永久調整

```
$ vi /etc/sysctl.conf
net.core.somaxconn=4096
```

## Reuseport

```
server {
    listen 443 backlog=65536 reuseport;
}
```

> https://veithen.io/2014/01/01/how-tcp-backlog-works-in-linux.html

## TW

```
sysctl net.ipv4.tcp_fin_timeout
```