# MySQL 資料庫相關命令
Published by Yuki on 2015/10/15

最近經常使用資料庫，所以整理了資料庫相關指令。

 

## 安裝與 root 密碼建置

```bash
[root@MySQL ~]# yum -y install mysql-server
[root@MySQL ~]# /usr/bin/mysql_secure_installation mysql -u root -p
⋯⋯
Enter current password for root (enter for none): 
# 如果才剛安裝，或是沒設定root密碼，直接Enter即可
⋯⋯
Remove anonymous users? [Y/n] y
# 移除匿名使用者
⋯⋯
Disallow root login remotely? [Y/n] n
# 拒絕root遠端登入
⋯⋯
Remove test database and access to it? [Y/n] y
# 移除test database 和存取
⋯⋯
Reload privilege tables now? [Y/n] y
# 重新載入權限表單
⋯⋯
```

## 建立 database 與 使用者，以及使用者權限配置和允許連線位置

```bash
[root@Yuki ~]# mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.1.73 Source distribution
Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights
reserved.
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input
statement.
mysql> create database Database;
# Database 為資料庫名稱，自行命名
Query OK, 1 row affected (0.00 sec)
mysql> create user 'YUKI'@'10.211.55.9' identified by 'password';
# YUKI = 使用者; 10.211.55.13 = 允許連線IP; password = 使用者密碼
# 允許連線IP可使用 % 符號，代表允許所有IP連線
Query OK, 0 rows affected (0.00 sec)
mysql> GRANT ALL PRIVILEGES ON `Datadase`.* TO 'YUKI'
->@'10.211.55.13' WITH GRANT OPTION;
# 允許所有權限 在 Database 這資料庫上
# .* 所有資料表
# TO 'YUKI'給使用者 
# 與 @'10.211.55.13' 此IP位置連線使用 
Query OK, 0 rows affected (0.00 sec)
mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)
mysql> QUIT;
```

## 查詢 MySQL 的現有使用者與允許連線位置，以及所有資料庫

```bash
mysql> select host,user from mysql.user;
+-----------+------+
| host      | user |
+-----------+------+
| 127.0.0.1 | root |
| localhost | root |
| mysql     | root |
+-----------+------+
3 rows in set (0.00 sec)
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
+--------------------+
2 rows in set (0.00 sec)
mysql> show tables;
ERROR 1046 (3D000): No database selected
# 因為一開始全新安裝，並不會有資料表
```

## 使用指令更改使用者密碼

```bash
[root@MySQL ~]# mysqladmin -u root -p password '123456'
Enter password: 
# 使用這必須有最高權限
# 成功不會有顯示資訊
```

## 使用登記使用者帳戶中的密碼欄位

```bash
[root@MySQL ~]# mysql -u root -p
Enter password: 
⋯⋯
mysql> use mysql;
# 使用 mysql 資料庫
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A
Database changed
mysql> UPDATE user SET Password=PASSWORD("1234567") WHERE User='root';
# UPDATE = 更新 user 資料表
# SET Password = 設定 password 欄位 為 1234567
# WHERE = 搜索條件
# 區分主機的話，可在條件加上 AND Host = 'localhost'
Query OK, 3 rows affected (0.00 sec)
Rows matched: 3  Changed: 3  Warnings: 0
mysql> flush privileges;
# 更新資料庫
```

## 移除使用者及允許登入位置

```bash
mysql> revoke all privileges on *.* from YUKI@localhost;
Query OK, 0 rows affected (0.00 sec)
# 移除使用者本機登入管理權限
mysql> revoke all privileges on *.* from YUKI@10.211.55.9;
Query OK, 0 rows affected (0.00 sec)
# 移除使用者遠端登入管理權限
mysql> delete from mysql.user where user='YUKI';
Query OK, 2 rows affected (0.00 sec)
# 刪除使用者
mysql> 
```

## 匯出或匯入

```bash
[root@MySQL ~]# mysqldump -u root -p Test > backup.sql
Enter password: 
# 正確匯出資料庫
[root@Yuki ~]# ls -l
⋯⋯
-rw-r--r--. 1 root root 1254 2015-10-13 21:10 backup.sql
[root@MySQL ~]# mysql -u root -p Test < backup.sql
Enter password:
# 正確匯入資料庫
[root@MySQL ~]#  mysql -u root -p data < backup.sql
Enter password: 
ERROR 1049 (42000): Unknown database 'data'
# 錯誤，找不到所輸入的 Database
[root@MySQL ~]#
```