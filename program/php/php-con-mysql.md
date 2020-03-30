# php 連接 MySQL 程式簡易範例
Published by Yuki on 2015/10/11

最近想做登入以及查詢的系統，所以就用到 php 連接到 MySQL 查詢資料。

單純研究安裝，而沒去設置防火牆，所以在實作前請先關閉防火牆，如您自己有設置好防火牆，可以不理會此步驟。

```bash
[root@Yuki ~]# service iptables stop
```

下面 php 為較簡易測試 MySQL 是否連接成功
```php
<?php
 
header('Content-Type:text/html;charset=utf-8');
 
if(! mysql_connect("localhost","root","1234567"))
//localhost = 主機位址; root = 使用者; 1234567 = 密碼
    die("connect false");
//die = 執行到此行，將字串輸出後結束程式
    else echo 'OK!';
 
mysql_select_db("yuki");
//yuki = 資料庫名稱
$sql = 'select * from test';
//test = 選取資料表
$result = mysql_query($sql);
 
$row = mysql_fetch_array($result);
//輸出第一筆資料
echo '
Number:';
echo $row['Number'];
//選取第一筆資料的Number欄位輸出
 
?>
```

下面則是將所有資料輸出並排版好

```php
<?php
 
header('Content-Type:text/html;charset=utf-8');
 
if(!mysql_connect("localhost","root","1234567"))
        die("connect fail");
    else echo 'database server connect Success.';
 
     
if(!mysql_select_db('yuki'))
        die("can't use database server");
    else echo 'database connect Success.';
 
mysql_query("SET NAMES 'UTF8'");
$sql='select * from test';
$result=mysql_query($sql);
 
echo"
<table width=546 border=1 align=center cellspacing=0 cellpadding=0>
//建立欄位與名稱
        <tr>
            <td>Number</td>
            <td>Name</td>
            <td>Cache</td>
            <td>Pay</td>
            <td>Date</td>
        </tr>";
 
while($row=mysql_fetch_array($result))
    {
        echo"<tr>
                <td>$row[0]</td>
                <td>$row[1]</td>
                <td>$row[2]</td>
                <td>$row[3]</td>
                <td>$row[4]</td>
            </tr>";
        }
     
 
?>
```