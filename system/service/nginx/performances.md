# Performance Tuning

## Note

- worker
    - num
    - connections
- openfile
- backlog
- reuseport
- ssl_cipher
- keepalive
- limit connections
- data expire
- timeout
    - FIN - ACK
    - nginx
- log buffer

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

`backlog` 是限制 TCP 全連接佇列的數值，其預設值為 `511`，如果要讓 nginx 能承受更大的流量，可以調整該數值。

查看當前的佇列（`Send-Q`）大小：

```
$ ss -ltn
State        Recv-Q       Send-Q               Local Address:Port                Peer Address:Port       Process
LISTEN       0            511                        0.0.0.0:80                     0.0.0.0:*
```

而該數值與 `net.core.somaxconn` 是有所關聯，其值為兩變數（`somaxconn`, `backlog`）的最小值：

```
$ sysctl -a | grep net.core.somaxconn
net.core.somaxconn = 4096
```

>  Since Linux 5.4 it was increased to 4096.

> 從上面兩個指令輸出，即可以判斷該 nginx 的配置為預設。在較舊的 linux kernel 中，`net.core.somaxconn` 的預設數值為 `128`，這時 `ss` 就會看到 `Send-Q` 為 `128`。

> Old versions of Linux kernel have nasty bug of truncating somaxcon value to it's 16 lower bits (i.e. casting value to uint16_t), so raising that value to more than 65535 can even be dangerous. 

全連接調整完後，就要考慮半連接是否足夠，因為當半連接佇列不足時，就會丟棄後面接收的 **SYN**，所以這是需要評估的一環：

```
$ sysctl -a | grep tcp_max_syn_backlog
net.ipv4.tcp_max_syn_backlog = 4096
```

> 半連接的有效數值約是 `tcp_max_syn_backlog * 3/4`
>
> https://github.com/torvalds/linux/blob/master/net/ipv4/tcp_input.c#L7154
>
>
>> 在 Linux 3.19 中，`tcp_max_syn_backlog` 的初始值代碼 - 
>>
>> https://github.com/torvalds/linux/blob/v3.19-rc7/net/core/request_sock.c#L48
>>

> 如果有啟用 `tcp_syncookies`，可以忽略半連接設置。

使用下面指令，查看目前 tcp 狀態為 `SYN-RECV` 的連線數，如果該數值過高，也得適時調整 `tcp_max_syn_backlog`：

```
$ ss -at | grep SYN-RECV | wc -l
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

## keepalive

```
/proc/sys/net/ipv4/ip_local_port_range
```

## 參考

https://www.alibabacloud.com/blog/599203
