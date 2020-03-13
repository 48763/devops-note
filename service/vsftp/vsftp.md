# vsFTP

Published by Yuki on 2014/11/18

## 目錄
- 安裝使用
- 禁止匿名登入
- 允許 root 登入
- 限制用戶登入
- 限制用戶目錄
- SELinux
- 其它

## 安裝使用

### 安裝

```bash
[root@Yuki ~]# yum install -y vsftpd
```

### 服務啟用

```bash
[root@Yuki ~]# service vsftpd start
# start = 啟用
# stop = 停用
# restart = 重啟
```

### 配置檔

```bash
[root@Yuki ~]# vi /etc/vsftpd/vsftpd.conf
```

### 登入

```bash
[root@Yuki ~]# ftp localhost
Trying ::1...
ftp: connect to address ::1連線被拒絕
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
220 (vsFTPd 2.2.2)
Name (localhost:root): 
``` 

## 禁止匿名登入

預設允許匿名(anonymous)登入

```bash
[root@Yuki ~]# ftp localhost
Trying ::1...
ftp: connect to address ::1連線被拒絕
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
220 (vsFTPd 2.2.2)
Name (localhost:root): anonymous
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> 
```

進入至配置檔更改參數

```bash
anonymous_enable=NO
# 預設為 YES
# 禁只匿名登入
``` 

再次使用匿名(anonymous)登入

```bash
[root@Yuki ~]# ftp localhost
Trying ::1...
ftp: connect to address ::1連線被拒絕
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
220 (vsFTPd 2.2.2)
Name (localhost:root): anonymous
331 Please specify the password.
Password:
530 Login incorrect.
Login failed.
ftp> 
```

## 允許 root 登入

使用 root 登入，預設為拒絕

```bash
[root@Yuki ~]# ftp localhost
Trying ::1...
ftp: connect to address ::1連線被拒絕
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
220 (vsFTPd 2.2.2)
Name (localhost:root): root
530 Permission denied.
Login failed.
ftp> 
```

進入下列兩配置檔，將 root 註解(#)

```bash
[root@Yuki ~]# vi /etc/vsftpd/ftpusers 
[root@Yuki ~]# vi /etc/vsftpd/user_list 
``` 

再次使用 root 登入

```bash
[root@Yuki ~]# ftp localhost
Trying ::1...
ftp: connect to address ::1連線被拒絕
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
220 (vsFTPd 2.2.2)
Name (localhost:root): root
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> 
```

## 限制用戶登入

限制用戶登入的方式有兩種
1.拒絕所有，只允許名單內用戶（少部分人能使用）
2.允許所有，只拒絕名單內用戶（大部分人能使用）

```bash
[root@Yuki ~]# vi /etc/vsftpd/vsftpd.conf
…
userlist_enable=YES
userlist_deny=NO
# NO = 不拒絕使用者清單內的用戶，其餘拒絕
# YES = 拒絕使用者清單內的用戶，其餘拒絕
[root@Yuki ~]# vi /etc/vsftpd/user_list 
# 使用者清單
```

## 限制用戶目錄

vsFTP預設使用者可以使用 “cd” 移動位置

```bash
[root@localhost ~]# ftp localhost
Trying ::1...
ftp: connect to address ::1連線被拒絕
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
220 (vsFTPd 2.2.2)
Name (localhost:root): Yuki
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> pwd
257 "/home/Yuki"
ftp> cd ../..
250 Directory successfully changed.
ftp> pwd
257 "/"
ftp> ls -l
227 Entering Passive Mode (127,0,0,1,59,123).
150 Here comes the directory listing.
dr-xr-xr-x    2 0        0            4096 Oct 10 13:24 bin
dr-xr-xr-x    5 0        0            1024 Oct 10 13:24 boot
drwxr-xr-x   19 0        0            3720 Oct 10 13:26 dev
``` 

禁止名單內用戶離開自己的Home目錄

```bash
[root@Yuki ~]# vi /etc/vsftpd/vsftpd.conf
…
chroot_local_user=YES　　//限制使用者在自己的加目錄
chroot_list_enable=YES　　//寫入列表功能
[root@Yuki ~]# vi /etc/vsftpd/chroot_list
Yuki
```

再次登入，使用 “cd” 查看
```bash
[root@localhost ~]# ftp localhost
Trying ::1...
ftp: connect to address ::1連線被拒絕
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
220 (vsFTPd 2.2.2)
Name (localhost:root): Yuki
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> pwd
257 "/"
ftp> cd ../..
250 Directory successfully changed.
ftp> ls -l
227 Entering Passive Mode (127,0,0,1,155,8).
150 Here comes the directory listing.
226 Directory send OK.
ftp> pwd
257 "/"
ftp> 
```

## SELinux

登入發現有錯誤訊息「500 OOPS: cannot change directory:/home」

```bash
[root@localhost ~]# ftp localhost
Trying ::1...
ftp: connect to address ::1連線被拒絕
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
220 (vsFTPd 2.2.2)
Name (localhost:root): root
331 Please specify the password.
Password:
500 OOPS: cannot change directory:/root
Login failed.
ftp> 
```

查看 SELinux

```bash
[root@Yuki ~]# getsebool -a | grep ftp
allow_ftpd_anon_write --> off
allow_ftpd_full_access --> off
allow_ftpd_use_cifs --> off
allow_ftpd_use_nfs --> off
ftp_home_dir --> off
ftpd_connect_db --> off
ftpd_use_fusefs --> off
ftpd_use_passive_mode --> off
httpd_enable_ftp_server --> off
tftp_anon_write --> off
tftp_use_cifs --> off
tftp_use_nfs --> off
``` 

啟用 ftp 使用 home 的權限

```bash
[root@Yuki ~]# setsebool -P ftp_home_dir=1
```

啟用後，再次登入就不會出現錯誤了！

## 其它

那麼就是有套件需要補齊！

```[root@Yuki ~]# ftp localhost
ftp:command not found
```