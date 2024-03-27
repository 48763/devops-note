# Azure

## CLI 安裝

```
$ curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

## Go SDK 安裝

### Go 

```
$ wget https://go.dev/dl/go1.22.1.linux-amd64.tar.gz
$ rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz
$ export PATH=$PATH:/usr/local/go/bin
```

### SDK

```
$ go install github.com/Azure/azure-sdk-for-go/...@latest
```

> 用戶存取的 [`env`](https://learn.microsoft.com/en-us/azure/developer/go/azure-sdk-authentication?tabs=bash#-option-1-define-environment-variables) 設置