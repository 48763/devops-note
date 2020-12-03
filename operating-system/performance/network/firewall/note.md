# Note

## mangle

主要用於修改資料包的 TOS（Type Of Service，服務型別）、TTL（Time To Live，生存週期）指以及為資料包設定 Mark 標記，以實現 Qos(Quality Of Service，服務質量)調整以及策略路由等應用，由於需要相應的路由裝置支援，因此應用並不廣泛。

表對應的核心模組為 iptable_mangle。

## raw

自 1.2.9 以後版本的 iptables 新增的表，主要用於決定資料包是否被狀態跟蹤機制處理。在匹配資料包時，raw 表的規則要優先於其他表。

raw 表對應的核心模組為 iptable_raw

封包在 RAW 表處理完後，將跳過 NAT 表和 `ip_conntrack` 處理，即不再做地址轉換和封包的鏈接跟踪處理了。


[Docker firewall](https://blog.csdn.net/taiyangdao/article/details/88844558)