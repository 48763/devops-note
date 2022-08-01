# 負載均衡器

負載均衡器（ELB, Elastic Load Balancing）可以將訪問的流量進行分流，其分流的配比是按照監聽器對目標群組（target group）的權重（witght）設置。並且負載均衡器可以透過全站加速器（global accelerator），以提升用戶的訪問速度（官方數據表示約提升 60%）。

負載均衡器有以下類型：
- [Application](#application)
- [Network](#network)
- Gateway
- Classic（8月 15, 2022 停止該服務）

## Application

stickiness 有兩種
- target group 設定 Stickiness
- LB 設定 Group-level stickiness

## Network

