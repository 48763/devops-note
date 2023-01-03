# 應用腳本

自製腳本列表。

## 列表

- [lmc](#lmc)
- [ns](#ns)
- [print-connection-map](#print-connection-map)
- [rename](#rename)

## 介紹

### [lmc](./lima)

Lima 透過 yaml 生成虛擬機時，僅按照檔案名稱命名虛擬機，故創建該腳本，可以使用「自己的預設範本」或「指定範本」創建虛擬機時，仍可以自定義虛擬機名稱，並解在創建完畢後，會輸出 `ssh` 連線資訊。

### [ns](./ns)

ns 是基於 nslookup 的延伸應用，可以直接貼上網址查詢域名的解析，並且可以接受多筆查詢，或者是查詢域名轉跳後的解析。

### [print-connection-map](./nginx/print-connection-map.sh)

可以一次輸出 nginx 所有 conf 中，所配置的 `server_name` 和 `proxy_pass` 對應列表，也包含了配置中的 `set` 替換成對應的變量值。

### [rename](./rename.sh)

一次變更目錄底下的檔案名稱，英文全部統一小寫，` ` 全部替換成 `-` 。
