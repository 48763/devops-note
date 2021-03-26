# 實例

```
$ gcloud compute instances describe main-exchange-nod-eth-ssd --format="(machineType,disks[].deviceName,status)"
```

```
gcloud compute disks list --filter=name=main-exchange-nod-eth-ssd
```
