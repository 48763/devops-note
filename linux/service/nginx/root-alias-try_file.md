# root 與 alias 使用 try_files 差異

虛擬主機的基礎配置：

```nginx
server {
    listen 80 default_server;

    root /etc/nginx/web;
    index index.html;

    access_log /var/log/nginx/host.log combo;
}
```

想觀察訪問路徑的變化，所以在 `http` 內新增自訂義的 log 格式：

```nginx
log_format combo
    'document_root $document_root'
    ', document_uri $document_uri'
    ', uri $uri'
    ', realpath_root $realpath_root'
    ', request_filename $request_filename'
    ', request_uri $request_uri';
```

## root

將下面配置，添加至 `server` 內：

```nginx
location /root/ {
    root /etc/nginx/web/path/;
    try_files $uri ${uri}index.html;
}
```

觀察下面輸出，會發現實際的 `request_filename` 是 `root` + `uri` 所組合。

```bash
$ curl localhost/root/index.html
root

$ cat host.log
document_root /etc/nginx/web/path
document_uri /root/index.html
uri /root/index.html
realpath_root /etc/nginx/web/path
request_filename /etc/nginx/web/path/root/index.html
request_uri /root/index.html
```

觀察下面輸出，會發現雖然 `request_uri` 雖然只有 `/root/`，但因為 `try_files` 設置 `$uri/index.html`，所以 `document_uri` 與 `uri` 都會多加 `index.html`。

```bash
$ curl localhost/root/
root
$ cat host.log
document_root /etc/nginx/web/path
document_uri /root/index.html
uri /root/index.html
realpath_root /etc/nginx/web/path
request_filename /etc/nginx/web/path/root/index.html
request_uri /root/
```

## alias

將下面配置，添加至 `server` 內：

```nginx
location /alias/ {
    alias /etc/nginx/web/path/;
    try_files $uri ${uri}index.html;
}
```

觀察下面輸出，會發現實際的 `request_filename` 是 `uri` 中的 `/alias/` 會被置換成設置的路徑。

```bash
$ curl localhost/alias/index.html
alias

$ cat host.log
document_root /etc/nginx/web/path/
document_uri /alias/index.html
uri /alias/index.html
realpath_root /etc/nginx/web/path
request_filename /etc/nginx/web/path/index.html
request_uri /alias/index.html
```

觀察下面輸出，在使用 `try_files` 時，`realpath_root` 會變成 `server` 底下的 `root` 路徑。

```bash
$ curl localhost/alias/
<html>
<head><title>404 Not Found</title></head>
<body bgcolor="white">
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.14.0 (Ubuntu)</center>
</body>
</html>

$ cat host.log
document_root /etc/nginx/web
document_uri index.html
uri index.html
realpath_root /etc/nginx/web
request_filename /etc/nginx/webindex.html
request_uri /alias/
```
> 目前不曉得是不是正常...


因為覺得會 `404` 很奇怪，索性在把 `$uri` 多加一個，看請求路徑會怎樣：

```nginx
location /alias/ {
    alias /etc/nginx/web/path/;
    try_files $uri ${uri}${uri}index.html;
}
```

於是就好了...

```
$ curl localhost/alias/index.html
alias

$ cat host.log
document_root /etc/nginx/web/path/
document_uri /alias/index.html
uri /alias/index.html
realpath_root /etc/nginx/web/path
request_filename /etc/nginx/web/path/index.html
request_uri /alias/
```

