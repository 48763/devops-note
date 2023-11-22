# HaProxy 配置
Published by Yuki on 2015/02/12

主電腦只安裝 HaProxy，以便觀察、測試或是管理用。

單純研究安裝，而沒去設置防火牆，所以在實作前請先關閉防火牆，如您自己有設置好防火牆，可以不理會此步驟。

```
[root@Yuki ~]# service iptables stop
```

## 安裝

```bash
[root@Yuki ~]# yum install -y haproxy
```

## 配置檔相關設定

```bash 
[root@Yuki ~]# vim /etc/haproxy/haproxy.cfg
global
# to have these messages end up in /var/log/haproxy.log you will
# need to:
#
# 1) configure syslog to accept network log events.  This is done
#    by adding the '-r' option to the SYSLOGD_OPTIONS in
#    /etc/sysconfig/syslog
#
# 2) configure local2 events to go to the /var/log/haproxy.log
#   file. A line like the following can be added to
#   /etc/sysconfig/syslog
#
#    local2.*                       /var/log/haproxy.log
#
log         127.0.0.1 local2
chroot      /var/lib/haproxy        #haproxy安裝目錄
pidfile     /var/run/haproxy.pid    #將所有進程寫入pid文件
maxconn     4000                    #每隔進成可用的最大連接數
user        haproxy
group       haproxy
daemon      #以後台守護進程運行
#debug #調適模式
#quiet #安裝模式
#turn on stats unix socket
stats socket /var/lib/haproxy/stats
#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
mode                    http                #運行模式tcp、http
log                     global
option                  httplog
option                  dontlognull         #不紀錄健康檢查的日誌信息
option                  http-server-close   #每次請求完畢後主動關閉http通道
#option forwardfor                          #獲取客户端之時訪問IP
option                  redispatch
#如果後端有服務器關機，强制切换到正常服務器
retries                 3                   #三次連接失败，判斷服務不可用
timeout http-request    10s
timeout queue           1m
timeout connect         10s                 #連接超時
timeout client          1m                  #客户端超時
timeout server          1m                  #服務器超時
timeout http-keep-alive 10s
timeout check           10s                 #檢測超時
maxconn                 3000                #每個進程可用的最大連接數
#---------------------------------------------------------------------
# main frontend which proxys to the backends
#---------------------------------------------------------------------
frontend  main  #自定義描述信息
bind *:5000
acl url_static       path_beg       -i /static /images
/javascript /stylesheets
#規則設置
acl url_static       path_end       -i .jpg .gif .png .css .js
#規則設置
#---------------------------------------------------------------------
listen web
bind *:80               #監聽80端口
mode http
option httpclose
option forwardfor
# 後台伺服器
# weight  調節伺服器負重
# check   允許對該伺服器進行健康檢查
# inter   健康檢查之間的時間，單位為毫秒(ms)，默認值 2000(ms)
# rise    多少次連接成功後的檢查，認定伺服器處於可操作狀態，默認值2
# fall    多少次不成功的檢查後，認定伺服器為當掉狀態，默認值3
# maxconn 指定可被發送到該伺服器的做大併發連接數
server web1 192.168.190.140:80 weight 1 check
server web2 192.168.190.141:80 weight 1 check
#--------------------------------------------------------------------
listen ftp
bind *:21,*:10000-10250
mode tcp
option tcplog
server ftpserver 192.168.190.141 check inter 3000 port 21
#--------------------------------------------------------------------
listen admin_stat
bind *:8000                     # 監聽端口
mode http                       # http的7層模式
option httplog
log global
stats refresh 30s               # 統計頁面刷新時間
stats uri /haproxy              # 統計頁面URL
stats realm Haproxy\ Statistics # 統計頁面密碼框上提示文本
stats auth admin:admin          # 統計頁面用户名與密碼設置
stats hide-version              # 隱藏統計頁面上HAProxy的版本信息
```

各項服務的Port，必須設置不一樣，包含統計頁面，以免衝突到！

## 啟動服務
```
[root@Yuki ~]# service haproxy start
Starting haproxy:                                          [  OK  ]
``` 

### 檢測是否成功
```
http://192.168.190.130
```

```
ftp://192.168.190.130
```

### 進入到觀察頁面

```
http://192.168.190.130:8000/haproxy
```