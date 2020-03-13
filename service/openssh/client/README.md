# ssh-keygen

<!--
Secure Shell (SSH) is a cryptographic network protocol for operating network services securely over an unsecured network.
-->
SSH（Secure Shell）是一種加密的網路傳輸協定，可在不安全的網路中為網路服務提供安全的傳輸環境。

<!--
ssh-keygen is a standard component of the Secure Shell (SSH) protocol suite found on Unix and Unix-like computer systems. The ssh-keygen utility is used to generate, manage, and convert authentication keys.
-->
ssh-keygen （ssh key generate）是 SSH 協議套件的標準組件，可以在 Unix 和類似 Unix 的系統上找到。ssh-keygen 實用程序用於生成，管理和轉換認證密鑰。

## Foreword
當管理的主機越來越多，每台主機的管理員密碼就變成是問題，全部設定一致，會形成安全問題；設定不一樣，又得靠工具記。

於是想到了一個方法：admin -> (PubkeyAuthentication) -> remote-center -> （PubkeyAuthentication）-> host，管理員需要操作主機時，無法直接連接至 host；而是需要先遠端至 remote-center，再藉由 remote-center 才能遠端至 host。 ***（全程都使用金鑰認證）***

好處有：
1. 省了密碼設定問題，只需要設置 admin 連至 remote-center 這段的密碼。
2. 因為 remote-cneter 連至 host 都採用金鑰認證，所以就算管理的人員異動，直接在 remote-cneter 進行設定。

## Environment
- Hostename：Yuki-BMP
  - OS：OS X
  - 192.168.10.1
  
- Hostname：remote-center
  - OS：Ubuntu 14.04
  - IP：10.211.55.1
  
- Hostname：host
  - OS：Ubuntu 14.04
  - IP：10.211.55.7

## Table of contents
- [Generate key](generate-key)
- [Set key](set-key)
- [Set config about ssh](Set-config-about-ssh)
- [Convenient Script](convenient-Script)

## Generate key

首先，產生一組名稱為預設的非對稱金鑰，密碼僅有 Yuki-BMP 連接 remote-cneter 這段有設定。（remote-center 連接 host 所需要的金鑰生成方式亦同，故不重複演示。）
```bash
Yuki-BMP:~ Yuki$ ssh-keygen
Enter file in which to save the key (/Users/yuki/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /Users/yuki/.ssh/id_rsa.
Your public key has been saved in /Users/yuki/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:c9GPN7/zjUS1R8/+a2dQ69ThqsqO50bZJpnx4UWnmkQ yuki@Yuki-MBP
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|           E . . |
|          o o o o|
|         . + = =+|
|        S @ * *oB|
|         O B o.Bo|
|        . o   =.o|
|        oo   o =*|
|       .==... o+O|
+----[SHA256]-----+
```

## Set public key

設置公鑰至 remote-center。（remote-center 連接 host 的公鑰設定方式亦同，故不重複演示。不過在該段沒設密碼，將不會要求輸入密碼，而是直接登入。）
```bash
Yuki-BMP:~ Yuki$ ssh-copy-id -i ~/.ssh/id_rsa Yuki@10.211.55.1
Yuki-BMP:~ Yuki$ ssh Yuki@10.211.55.1
Enter passphrase for key '/Users/yuki/.ssh/id_rsa': 
```

## Set config about ssh

當設置金鑰非預設名稱 `id_ras` 時，就需要設定 config 來區別各連結的用戶。（以 Yuki-BMP 連接 remote-center 為例。）
```bash
Yuki-BMP:~ Yuki$ vi .ssh/config
Host remote-center
        HostName 10.211.55.1
        User Yuki
        IdentityFile ~/.ssh/id_rsa

Yuki-BMP:~ Yuki$ ssh remote-center
Enter passphrase for key '/Users/yuki/.ssh/id_rsa': 
```

在設定 remote-center，僅允許管理員（Yuki）用金鑰認證登入。
```bash
Yuki@remote-center:~$ sudo vi /etc/ssh/sshd_config
Match User Yuki
        PasswordAuthentication no
        PubkeyAuthentication yes
        
Yuki@remote-center:~$ sudo service ssh restart
```

## Convenient Script

因為設定的主機太多，所以自己寫了一個腳本方便運行。
```bash
Yuki@remote-center:~/.ssh$ ./script.sh . client 192.168.200.30
# ./script.sh directory hostname ip-address
```
