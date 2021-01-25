# GCP DNS 更新

該腳本設定完畢後，可以使用 *crontab* 或是建置 *jenkins* 流程，手動/自動的更新雲端解析。

- [運行腳本](#運行腳本)
- [環境配置](#環境配置)
- [主機命名](#主機命名)
- [添加解析](#添加解析)
- [災害復原](#災害復原)

## 運行腳本

在該腳本目錄裡執行：

```
$ ./gen.sh && ./launch.sh
```

生成的 `.zone` 檔案位置預設在 `./ccdns/`，如果需要更改，參考[環境配置](#環境配置)。

## 環境配置


| 變數 | 解釋 | 預設 |
| - | - | - |
| WORKDIR | 程序運行時的工作目錄路徑。 | `./ccdns` |
| PIDFILE | 程序的 pid 放置路徑。 | `${WORKDIR}/pid` |
| ZONEDIR | zone 的模板放置路徑。 | `./zone` |
| GCP_ZONE | 程序生成的 zone 放置路徑。 | `${WORKDIR}/gcp.zone` |
| PROJECTS | 要迭代的 gcp 專案 id，多個專案以空白分隔。 | `project-id-str01 project-id-str02` |

## 主機命名

創建服務時的名稱格式：

```
{環境}-{產品/專案名稱}-{服務/應用}-{地區簡稱}-序號
```

### 範例：

```
sit-gam-mysql-tw-01
```
- 環境：sit
- 產品/專案名稱：gam
- 服務/應用：mysql
- 地區簡稱：tw
- 序號：01

## 添加解析

當有新的專案產生時，請到 [gcp.zone](./zone/gcp.zone) 添加註解，以利於區分專案區塊，格式如下：

```
;{環境}-{專案名稱}
```

> 在 [gcp.zone](./zone/gcp.zone) 檔案內，不要註解專案名稱以外的東西。

專案在創建主機（instances）、資料庫（sql）和 redis，都不需要手動添加解析，腳本在每次更新時，便會自動抓取 GCP 上面其服務的內部 IP，以更新 DNS 解析。

### 何時需要手動添加？

**(1.)** 在選擇香港地區創建 redis，或是 **(2)** 需要新的主機名稱指向到現有的主機（instances）時，就必需到 [gcp.zone](./zone/gcp.zone) 手動添加解析，到對應的專案名稱註解下。格式如下：

```
;{環境}-{專案名稱}
OTHER-SERVICE-OR-SERVER-NAME    IN  A 127.0.0.1
```

> 如果需要添加 CNAME 時，請確定 DNS 下次查詢，是訪問到其它 DNS，否則將沒意義，甚至導致不必要的頻寬損耗。所以在通常情況，請直接使用主機的 IP 位址。

## 災害復原

修改下面指令中的 `<file-path>` 和 `<zone-name>`，利用 Google SDK 更新解析：

```
$ gcloud dns record-sets import <file-path> \
    --zone <zone-name> \
    --delete-all-existing \
    --replace-origin-ns \
    --zone-file-format \
    --project <project-id>
```

範例：

```
$ gcloud dns record-sets import ./ccdns/gcp.zone \
    --zone gcp-domain-com \
    --delete-all-existing \
    --replace-origin-ns \
    --zone-file-format \
    --project project-id-str
```
