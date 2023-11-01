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

Default value: `511`

```
$ ss -ltn
```

```
$ sysctl -a | grep net.core.somaxconn
$ sysctl -a | grep net.ipv4.tcp_abort_on_overflow
```

```
$ sysctl -w net.core.somaxconn=4096
```

> Old versions of Linux kernel have nasty bug of truncating somaxcon value to it's 16 lower bits (i.e. casting value to uint16_t), so raising that value to more than 65535 can even be dangerous. 

>  Since Linux 5.4 it was increased to 4096.


```
$ vi /etc/sysctl.conf

net.core.somaxconn=4096
```

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