# CURL


```
$ curl [-X HTTP_METHOD] \
    [-fiIkLsSv] \
    [--data-binary @-|@FILE] \
    [-m seconds] \
    [-o FILE]
    [--unix-socket][-w ]
```

### -X 

指定請求方法：

```
$ curl -X GET|HEAD|POST|PUT|DELETE http://localhost
```

### -f

靜音 HTTP 錯誤（不包含高於 400 的錯誤代碼）：

```
$ curl -fsS https://httpbin.org/status/404
```

> 如果用 `-s`，必須加上 `-S` 才會顯示錯誤代碼。 

### -i

輸出與 HTTP 伺服器溝通完成後的標頭：

```
$ curl -i https://httpbin.org/status/200
```

> 可以使用 `-v`

下面是 `curl -iL google.com` 和 `curl -IL google.com` 輸出標頭的差異（底下是取 `-i`）：

```
Expires: -1
Cache-Control: private, max-age=0
Accept-Ranges: none
Vary: Accept-Encoding
```

### -I

僅輸出一開始的標頭資訊：

```
$ curl -I https://httpbin.org/status/200
```

### -k

允許 SSL 連線不看憑證：

```
$ curl -k https://localhost
```

### -L

跟隨導向：

```
$ curl -L https://httpbin.org/status/301
```

### -s

靜音模式：

```
$ curl -s https://httpbin.org/status/200
```

### -S

當使用 `-s` 時，如果錯誤發生，會將其顯示：

```
$ curl -fsS https://httpbin.org/status/401
```

### -v

顯示與服務器溝通的詳細過程：

```
$ curl -v https://httpbin.org/status/200
```

### --data-binary

HTTP `POST` 位元組資料：

```
$ curl --data-binary @filename https://localhost
```

也可以用：

```
$ cat file | curl --data-binary @- https://localhost
```

### -m

允許傳輸的時間：

```
$ curl -m 1 https://localhost
```

### -o

把標準輸出寫入到檔案：

```
$ curl -o /dev/null https://localhost
```

### --unix-socket

通過 unix 域名接口連線：

```
$ curl --unix-socket /var/run/docker.sock \
    http://localhost/v1.40/images/json
```

> 範例是使用 docker 的 sock

### -w 

HTTP 完成後，輸出格式化資訊：

```
$ curl https://httpbin.org/status/200 -w "%{remote_ip}\n"
```

也可以用

```
$ cat format_file | curl https://httpbin.org/status/200 -w @-
```
