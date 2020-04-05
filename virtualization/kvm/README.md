# OSX on KVM

## 實驗環境：

- OS：Ubuntu 18.04 Desktop

## CPU 虛擬化

### 檢查

必須先檢查系統 BIOS，是否有啟用 CPU 虛擬化。

#### OSX

[1]
```
$ sysctl -a | grep machdep.cpu.features
$ sysctl -a | grep -o VMX
```

#### Linux

[2]
```
$ egrep -c '(vmx|svm)' /proc/cpuinfo
```


### 啟用

#### BIOS

CPU 架構及虛擬化選項：

- Intel：VT-x
- AMD：SVM

#### VM 

如果用 VBoxManage 創建虛擬機，用下列指令啟用：

```
$ VBoxManage modifyvm "ubuntu 18.04" --nested-hw-virt on
```

## 安裝 OSX

### 安裝 KVM．

[３]
```
$ sudo apt-get install qemu uml-utilities virt-manager dmg2img git wget libguestfs-tools
```

啟用忽略 MSRs（[Model-specific registers](https://en.wikipedia.org/wiki/Model-specific_register)）：
```
$ sudo su -c "echo 1 > /sys/module/kvm/parameters/ignore_msrs"
```

> 當用戶嘗試存取不支援的 MSRs，通常會導致應用/系統崩潰。這類的問題可以通過設置 kvm 選項：`ignore_msrs` 解決。[3]

克隆專案 *OSX-KVM*，並複製裡面的 `kvm.conf` 進行本地的 kvm 配置：
```
$ git clone https://github.com/kholia/OSX-KVM.git
$ cd OSX-KVM
$ sudo cp kvm.conf /etc/modprobe.d/kvm.conf
```

### 製作 macOS 鏡像檔

下載 OSX 系統：
```
$ ./fetch-macOS.py
#    ProductID    Version    Build   Post Date  Title
 1    061-77704    10.15.4  19E242d  2020-02-26  macOS Catalina Beta
 2    041-40615    10.15.4   19E266  2020-03-24  macOS Catalina
 3    041-91758    10.13.6    17G66  2019-10-19  macOS High Sierra
 4    041-88800    10.14.4  18E2034  2019-10-23  macOS Mojave
 5    061-26589    10.14.6   18G103  2019-10-14  macOS Mojave
 6    061-86291    10.15.3  19D2064  2020-03-23  macOS Catalina
 7    041-90855    10.13.5   17F66a  2019-10-23  Install macOS High Sierra Beta
 8    061-26578    10.14.5  18F2059  2019-10-14  macOS Mojave
 9    061-44345    10.15.2   19C39d  2019-11-15  macOS Catalina Beta

Choose a product to download (1-9): 
```

將 dmg 轉換成 img：
```
$ qemu-img convert BaseSystem.dmg -O raw BaseSystem.img
```

### 創建硬碟

```
$ qemu-img create -f qcow2 mac_hdd_ng.img 128G
```

> 硬碟效能幾近原生。

### 網路配置

```
$ sudo ip tuntap add dev tap0 mode tap
$ sudo ip link set tap0 up promisc on
$ sudo ip link set dev virbr0 up
$ sudo ip link set dev tap0 master virbr0
```


### KVM 載入

修改配置：
```
sed -i "s/CHANGEME/$USER/g" macOS-libvirt-NG.xml
```

載入配置：
```
$ virsh --connect qemu:///system define macOS-libvirt-NG.xml
```

開啟管理介面：
```
$ virt-manager
```

## 參考

- [1] user3439894, [How to check VT-x status on MacBook Pro
](https://apple.stackexchange.com/questions/224870/how-to-check-vt-x-status-on-macbook-pro/224879), English
- [2] virtualbox, [Ticket #19245](https://www.virtualbox.org/ticket/19245), English
- [3] archlinux, [QEMU](https://wiki.archlinux.org/index.php/QEMU#Certain_Windows_games/applications_crashing/causing_a_bluescreen), English