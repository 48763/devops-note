# 訪問路徑

## absolute_redirect

訪問 `/instances` 時，回傳 HTTP 標頭中的 `Location` 為相對路徑：

```nginx
location /instances {
    absolute_redirect off;
    proxy_pass  http://grafana:3000;
}    
```

## rewrite

改寫用戶端請求網址，再繼續匹配/退出匹配/返回轉址：

```nginx
location /instances {
    rewrite /instances/(.*) /$1  break;
    proxy_pass  http://grafana:3000;
}
```

> 標籤可以使用 last, break, redirect, permanent。
> - last：執行下一次 location 查詢。
> - break：退出 rewrite 模塊匹配。
> - redirect：永久轉址 http 代碼 307。
> - permanen：臨時轉址 http 代碼 301。

## alias

訪問 `/instances` 時，其代表 `/usr/share/nginx/html/`：

```nginx
location /instances {
    alias  /usr/share/nginx/html/;
    
    absolute_redirect off;
    proxy_pass  http://grafana:3000;
}
```

如果使用 `root`，實際訪問會是：

```
/usr/share/nginx/html/instances
```

而不是：

```
/usr/share/nginx/html
```

## proxy_redirect
