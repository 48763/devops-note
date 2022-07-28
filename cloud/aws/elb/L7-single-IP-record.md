# 應用層負載均衡器的單一位址解析

創建一個負載均衡器，預設要選擇至少兩個可用區域，但查詢解析（`nslookup`, `dig`）只有一個位址解析。

## 負載均衡器

應用層負載均衡器的跨區域（[***cross-zone***](#cross-zone)）負載均衡，始終會是啟用狀態；而其它的負載均衡器則是預設禁用。

> 始終啟用時 -  
> 使用 `describe-load-balancer-attributes` 不會列出 `CrossZoneLoadBalancing` 該屬性，也無法用 `modify-load-balancer-attributes` 對該屬性修改。

## cross-zone

在使用網路層負載均衡器，假設有兩個可用區，每個區域各有兩檯 EC2，各名稱與關係如下：

- 可用區: `AZ-A`
    - EC2: `A1`
    - EC2: `A2`
- 可用區: `AZ-C`
    - EC2: `C1`
    - EC2: `C2`

### 禁用

1. 當所有 EC2 為**健康**時，則所有可用區為**健康**。
2. 如果 `A1` 為**不健康**，則 `AZ-A` 為**不健康**，因為 `AZ-C` 為**健康**，所以負載均衡器的 DNS 解析僅會出現 `AZ-C` 的 IP。
3. 如果所有可用區都都為**不健康**，此時負載均衡器的 DNS 解析會同時出現所有區域的 IP。

### 啟用

1. 當所有 EC2 為**健康**時，則所有可用區為**健康**。
2. 如果 `A1` 為**不健康**，則 `AZ-A` 依然為**健康**，因為各區域都有**健康**的 EC2，所以負載均衡器的 DNS 解析會出現這兩個區域的 IP。
3. 如果所有可用區都都為**不健康**，此時負載均衡器的 DNS 解析會同時出現所有區域的 IP。

<!-->

[1]: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-disable-crosszone-lb.html#enable-cross-zone, "AWS, English, Enable cross-zone load balancing"

[2]: https://aws.amazon.com/premiumsupport/knowledge-center/elb-dns-cross-zone-balance-configuration/ "AWS, English, How does ELB DNS and traffic flow operate with different cross-zone load balancing configurations?"