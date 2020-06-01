# OpenSSL update

- [問題](./問題)
- [安裝](./安裝)
    - [Mac](./mac)
    - [Ubuntu](./ubuntu)
- [驗證](./驗證

## 問題

使用 `openssl` 檢查域名憑證時，發現 AC Root 過期：

```bash
$ openssl s_client -showcerts -servername gitlab.silkrode.com.tw -connect gitlab.silkrode.com.tw:443
CONNECTED(00000005)
depth=1 C = SE, O = AddTrust AB, OU = AddTrust External TTP Network, CN = AddTrust External CA Root
verify error:num=10:certificate has expired
notAfter=May 30 10:48:38 2020 GMT
verify return:0
```

## 安裝

### Mac


```bash
$ brew upgrade openssl
$ brew install openssl
$ brew link openssl
```

如果出現 `Refusing to link macOS` 的錯誤訊息，直接手動配置：
```bash
echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> ~/.bash_profile
```
> 注意終端機環機，我使用的是 *bash*

### Ubuntu 

```bash
$ sudo apt-get install --reinstall ca-certificates
```

## 驗證

再次使用後，就可以看到 AC root 已更新：

```bash
$ openssl s_client -showcerts -servername gitlab.silkrode.com.tw -connect gitlab.silkrode.com.tw:443
CONNECTED(00000005)
depth=2 C = US, ST = New Jersey, L = Jersey City, O = The USERTRUST Network, CN = USERTrust RSA Certification Authority
verify return:1
depth=1 C = GB, ST = Greater Manchester, L = Salford, O = Sectigo Limited, CN = Sectigo RSA Domain Validation Secure Server CA
verify return:1
depth=0 OU = Domain Control Validated, OU = PositiveSSL Wildcard, CN = *.silkrode.com.tw
verify return:1
```