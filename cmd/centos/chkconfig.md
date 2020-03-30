# Chkconfig
Published by Yuki on 2014/11/14

有時候都會檢查服務到底有沒有登入到表單中
所以必須檢查服務的狀況

檢視目前各服務狀態
```
[root@localhost ~]# chkconfig 
auditd          0:關閉    1:關閉    2:開啟    3:開啟    4:開啟    5:開啟    6:關閉
blk-availability0:關閉    1:開啟    2:開啟    3:開啟    4:開啟    5:開啟    6:關閉
crond           0:關閉    1:關閉    2:開啟    3:開啟    4:開啟    5:開啟    6:關閉
htcacheclean    0:關閉    1:關閉    2:關閉    3:關閉    4:關閉    5:關閉    6:關閉
httpd           0:關閉    1:關閉    2:關閉    3:關閉    4:關閉    5:關閉    6:關閉
...以下顯示省略...
[root@localhost ~]# chkconfig --list Service_Name
# Service_Name = 服務器名稱
[root@localhost ~]# chkconfig --list mysqld
mysqld          0:關閉    1:關閉    2:關閉    3:關閉    4:關閉    5:關閉    6:關閉
```

設定某個服務在該 level 下啟動 (on) 或關閉 (off)
level 0~6，共七個時間點，可以多重設定不同的點
```
[root@localhost ~]# chkconfig --level 0123456 Service_Name on||off
# 0123456 = 開機的各程序時段
# Service_Name = 服務器名稱
# on||off = 選擇啟用或是關閉
[root@localhost ~]# chkconfig --level 345 mysqld on
[root@localhost ~]# chkconfig --list mysqld
mysqld          0:關閉    1:關閉    2:關閉    3:開啟    4:開啟    5:開啟    6:關閉
``` 

這樣就設定完畢！
可以重新開機試試看！

> 備註：因為是使用 OS X 遠端登入至 Linux，系統語言也是中文，所以導致 Linux 某些顯示是中文化