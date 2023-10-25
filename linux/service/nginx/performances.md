# Performance Tuning

## Open File

```
$ ulimit -n
```

 1706  cat /proc/4673/limits
 1707  vi /lib/systemd/system/nginx.service

```
worker_processes = Number of CPUs ($ grep -c processor /proc/cpuinfo)
worker_rlimit_nofile = ( RLIMIT_NOFILE / worker_processes ) - 1024  
```

> NOFILE = number of open files
