# SELinux

## 安全設置

```
$ getenforce
Disabled
```

- Enforcing：強制模式，依據設定來限制檔案資源存取。
- Permissive：寬容模式，不限制檔案資源存取，但仍會依據設定檢查並記錄相關訊息。
- Disabled：停用模式，SELinux 已被停用。

系統配置：

```
$ vi /etc/selinux/config
```

> 需重啟才會生效。

臨時配置：

```
$ setenforce [ Enforcing | Permissive | 1 | 0 ]
```

## 預設傳輸埠

列出所有傳輸埠：

```
$ semanage port -l
```

添加新的傳輸埠：

```
$ semanage port -a -t http_port_t -p tcp 48763
```

## 參考

https://dotblogs.com.tw/echo/2017/06/19/linux_selinux_mode