# 創建實例

```
$ gcloud compute instances create first-vm \
    --network default \
    --subnet default \
    --zone asia-east1-a \
    --machine-type n1-custom-1-1024 \
    --image-project ubuntu-os-cloud --image-family ubuntu-1804-lts \
    --boot-disk-device-name first-vm \
    --boot-disk-type pd-standard \
    --boot-disk-size 10 \
    --no-address
```

> --can-ip-forward

- [Zone](#zone)
- [OS](#os)
- [Disk](#disk)
- [Machine Type](#machine-type)

### Zone

 - asia-east1-a
 - asia-east1-b
 - asia-east1-c
 - asia-east2-a
 - asia-east2-b
 - asia-east2-c

### [Operating system details](https://cloud.google.com/compute/docs/images/os-details)

| OS version | Image project | Image family |
| - | - | - |
| CentOS 8 | centos-cloud | centos-8 |
| CentOS 7 | centos-cloud | centos-7 |
| CentOS 6 | centos-cloud | centos-6 |
| Ubuntu 20.04 LTS | ubuntu-os-cloud | ubuntu-2004-lts |
| Ubuntu 18.04 LTS | ubuntu-os-cloud | ubuntu-1804-lts |
| Ubuntu 16.04 LTS | ubuntu-os-cloud | ubuntu-1604-lts |
| Ubuntu 14.04 LTS | ubuntu-os-cloud | ubuntu-1404-lts |

### Disk

- `pd-standard`
- `pd-ssd`

### Machine type

| Type | Memory | vCPU | M/vC |
| - | - | - | - |
| N1 | 1-624 | 1-96 | 0.9-6.5 |
| N2 | 1-640 | 2-80 | 0.5-8.0 |
| N2D | 1-768 | 2-96 | 0.5-8.0 |
| E2 | 1-128 | 2-32 | 0.5-8.0 |

> 1. The number of vCPUs must be a multiple of 2

> 2. Extended memory is not available for E2 machine types.

> 3. Increments of 0.25 GB for memory.