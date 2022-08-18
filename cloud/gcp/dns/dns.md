# DNS

## 創建 zone

```
gcloud beta dns managed-zones \
    create <zone_name> \
    --description="Temp zone." \
    --dns-name="<domain_name>" \
    --visibility="private" \
    --project=<projecr_id>
    --networks="<network_name>"
```

## 更新解析

```
gcloud dns record-sets import <file_name> \
    --zone <zone_name> \
    --delete-all-existing \
    --replace-origin-ns \
    --zone-file-format \
    --project <projecr_id>
```