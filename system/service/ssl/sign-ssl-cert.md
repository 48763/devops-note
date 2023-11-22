# 簽發憑證

## 相依安裝

```
$ apt update
$ apt install certbot python3-certbot-nginx
```

### 域名認證

- 網頁伺服器驗證
- 域名 txt 驗證

## 獲取證書

```
$ certbot --nginx -d example.com -d www.example.com
```

