# 邁智微電子（Actiontec Taiwan）DevOps Engineer 面試準備

> 對象職缺：DevOps Engineer
> 技術棧（依 JD）：Docker/K8s、CI-CD、GitOps、Terraform、Ansible、Jenkins、AWS、網路與資安、IoT streaming
> 面試流程（依面試趣）：通常兩關（線上一面 + 主管二面），難度偏低到普通

---

## 目錄
- [Part A：你該問公司的問題](#part-a你該問公司的問題)
- [Part B：技術問答（深入版）](#part-b技術問答深入版)
  - [1. 容器與編排 Docker / Kubernetes](#1-容器與編排-docker--kubernetes)
  - [2. CI/CD 與 GitOps](#2-cicd-與-gitops)
  - [3. IaC：Terraform / Ansible](#3-iacterraform--ansible)
  - [4. 雲端 AWS](#4-雲端-aws)
  - [5. 網路與資安基礎](#5-網路與資安基礎)
  - [6. 監控與維運](#6-監控與維運)
  - [7. Linux / Git](#7-linux--git)
  - [8. 加分題：IoT / Streaming](#8-加分題iot--streaming)
- [Part C：軟性 / 情境題](#part-c軟性--情境題)
- [最後提醒](#最後提醒)

---

# Part A：你該問公司的問題

分五類。前四類判斷這職位值不值得，第五類驗證調查發現的警訊（母集團加班文化、薪資偏低）。

## 1. 薪資與工時（最優先）
- 這個職缺的**薪資範圍**？年薪結構（本薪 ×N 個月＋獎金）？
- 是否有**常態加班**？平常幾點下班？趕交期時加班頻率？
- 加班有**加班費還是補休**？怎麼計算？
- 有沒有 **on-call**？輪班頻率、有無 on-call 加給？

> **判讀**：若回答閃爍、強調「大家很有熱情/使命感」卻不談具體制度 → 對應中國母集團「用奉獻道德綁架」的傳聞，要提高警覺。

## 2. 決策自主權與組織關係
- 台灣團隊的**技術決策自主，還是要報上海母集團（CIG）核可**？
- **回報線（reporting line）**在台灣還是海外？直屬主管背景？
- 基礎設施（AWS 帳號、K8s 叢集）是台灣自管還是共用集團的？權限誰核？

> **判讀**：自主權越低，發揮空間越小、卡關時越無力。

## 3. DevOps 團隊與職務現況
- DevOps 團隊**現在幾個人**？我是第一個還是有前輩帶？
- CI/CD、基礎設施是**從零建**還是接手既有系統？
- 這職位主要是**建置（build new）還是救火維運**？比例？
- JD 列了一長串工具，**實際到位多少**？

## 4. 公司穩定度與前景
- 台灣分公司未來 **1–2 年擴編計畫**？現在在招哪些職缺？
- 台灣負責的**產品/客戶專案**是長期穩定還是專案結束就有變數？
- 母公司美國客戶（如 Google Fiber Wi-Fi 7）專案，台灣參與程度？

## 5. 驗證警訊題（委婉問）
- 「公司 2024 年底才成立，想了解**團隊流動狀況**——這半年多有人離職嗎？」
- 「因為是新團隊，**文化目前偏向哪一種**——比較像美國那邊、還是上海集團的風格？」
- 是否需要簽**競業條款**？範圍與期間？（知乎提到 CIG 要求簽競業）
- 試用期多長、考核標準是什麼？

---

# Part B：技術問答（深入版）

每題附「面試官想聽到的關鍵字」與可能的追問。**準備好用自己的話講 + 一個真實案例**。

## 1. 容器與編排 Docker / Kubernetes

### Q：Docker image 怎麼縮小體積？
三招：
1. **選小 base image**：`alpine`（~5MB）或 Google 的 `distroless`（連 shell、套件管理都沒有，攻擊面最小）。
2. **Multi-stage build**：第一階段（builder）用完整 SDK 編譯，第二階段只 `COPY --from=builder` 把產出的二進位/靜態檔搬進乾淨小 image，編譯工具鏈全丟掉。Go/Java 尤其有效。
3. **減少 layer**：合併 `RUN`、同一層裝完就清快取（`apt-get install ... && rm -rf /var/lib/apt/lists/*`）；善用 `.dockerignore` 不把 `.git`、`node_modules` 打進去。

> **追問「為什麼 layer 順序重要？」**：Docker 有 build cache，把**最不常變的指令放前面**（如安裝依賴）、常變的（COPY 原始碼）放後面，改 code 時才不會每次都重裝依賴。

### Q：Container 和 VM 差在哪？
VM 靠 hypervisor 虛擬化硬體，**每台跑自己的完整 OS kernel**，隔離強但重、開機以秒/分計；container 共用宿主機 kernel，靠 Linux 的 **namespace（隔離視野：PID/NET/MNT…）+ cgroups（限制資源：CPU/記憶體）** 隔離，輕量、毫秒級啟動、密度高。代價是**隔離性較弱**（共用 kernel，kernel 漏洞會穿透），安全需求極高時仍會用 VM 或 Kata/gVisor 這類「安全容器」。

### Q：Pod / Deployment / Service / Ingress？
- **Pod**：最小部署單位，一到多個共享網路（同一 IP、可 localhost 互通）和 volume 的 container。Pod 是**短暫的**（會被殺、重建、換 IP）。
- **ReplicaSet**：維持指定數量的 Pod 副本（通常你不直接碰它）。
- **Deployment**：管 ReplicaSet，提供**宣告式更新、滾動升級、回滾**。
- **Service**：因為 Pod IP 會變，Service 給一組 Pod 一個**穩定的虛擬 IP + DNS 名稱**，並做 L4 負載平衡。類型：ClusterIP（叢集內）、NodePort、LoadBalancer（雲端 LB）。
- **Ingress**：L7 反向代理，用 host/path 規則把外部 HTTP/HTTPS 導到不同 Service，統一管 TLS 憑證。需搭配 Ingress Controller（Nginx、Traefik）。

### Q：Pod 一直 CrashLoopBackOff 怎麼 debug？
CrashLoopBackOff = 容器**啟動後又掛掉，K8s 反覆重啟並拉長重試間隔**。排查順序：
1. `kubectl describe pod <pod>` → 看 **Events**（ImagePullBackOff？OOMKilled？掛載失敗？probe 失敗？）
2. `kubectl logs <pod> --previous` → 看**上一個掛掉的容器**的日誌（關鍵，當前容器可能還沒起來）
3. 常見根因：應用啟動就報錯（設定/環境變數缺）、**OOMKilled**（memory limit 太低）、**liveness probe 太嚴**把還在暖機的容器殺掉、依賴的 DB/service 連不上。
4. 進去看：`kubectl exec -it <pod> -- sh`（若容器活得夠久）。

> **關鍵字**：describe 看 Events、logs --previous、OOMKilled、probe。

### Q：liveness / readiness / startup probe？
- **liveness**：探「還活著嗎」，失敗 → **重啟容器**（用於死鎖、卡住）。
- **readiness**：探「能接流量嗎」，失敗 → 把 Pod **從 Service endpoints 移除但不重啟**（暖機中、載入大檔、暫時過載時用）。
- **startup**：探「啟動完成了嗎」，成功前**暫停 liveness/readiness**，避免啟動慢的應用被 liveness 誤殺。

> **追問「liveness 設太敏感會怎樣？」**：應用只是短暫變慢就被重啟，可能引發雪崩式重啟。所以 threshold、period 要留餘裕。

### Q：滾動更新與回滾？
Deployment 預設 **RollingUpdate**，兩個旋鈕：
- `maxSurge`：更新時**額外**能多開幾個 Pod（衝量、快）。
- `maxUnavailable`：過程中**最多**幾個 Pod 不可用（保守、穩）。

逐批建新殺舊、服務不中斷。回滾：`kubectl rollout undo deployment/xxx`（保留 ReplicaSet 歷史，可回到指定 revision）。另一種策略是 `Recreate`（全殺再全建，會中斷，用於不能新舊並存的情況）。

### Q：ConfigMap vs Secret？
兩者都能以**環境變數**或**掛載檔案**注入設定，差別：
- **ConfigMap**：非敏感一般設定。
- **Secret**：敏感資料，值以 base64 儲存，可搭配 **RBAC 限制存取 + etcd encryption at rest**。

> **一定要主動補這句（展現資安意識）**：「base64 只是編碼不是加密，所以正式環境我會開 etcd 加密，或直接用外部的 Vault / AWS Secrets Manager 搭配 External Secrets Operator，不把明文放進 Git。」

### Q（可能延伸）：requests vs limits？
- **requests**：排程器據此決定 Pod 放哪個 node（保證量）。
- **limits**：硬上限，超 memory → **OOMKilled**，超 CPU → 被 throttle（節流不會被殺）。

---

## 2. CI/CD 與 GitOps

### Q：描述一條 commit 到 production 的完整 pipeline。
```
push → CI:
  - lint / static analysis
  - unit test
  - build image
  - security scan（image 漏洞 Trivy、SAST、依賴掃描）
  - push 到 image registry（tag = commit SHA）
→ CD:
  - 自動部 staging → 跑整合 / E2E 測試
  - 人工核可（prod gate）
  - 部 production（canary 或 blue-green）
  - 部署後 smoke test + 觀察監控
  - 異常 → 自動回滾
```
重點講出：**測試左移、image 用不可變 tag（SHA 而非 latest）、prod 前有 gate、部署後驗證與回滾**。

### Q：Jenkins pipeline 怎麼寫？
用 **Jenkinsfile** 放進 repo（pipeline as code，可版本控管、code review）。優先 **declarative** 語法：
```groovy
pipeline {
  agent { kubernetes { ... } }   // 動態起 pod 當 build agent
  stages {
    stage('Test')  { steps { sh 'make test' } }
    stage('Build') { steps { sh 'docker build ...' } }
    stage('Deploy'){ when { branch 'main' }; steps { ... } }
  }
  post { failure { ...通知... } }
}
```
- 憑證走 **Jenkins credentials store**（`withCredentials`），不寫死。
- build agent 用 **ephemeral（K8s plugin 動態起 pod）**，跑完就銷毀，環境乾淨。
- 複雜邏輯才用 scripted（Groovy）。

> **追問「Jenkins 的痛點？為何很多人轉 GitLab CI / GitHub Actions？」**：Jenkins 外掛生態雜、維護重、master 單點、設定散落。可誠實說知道有更輕量的選擇，但 Jenkins 仍是企業大宗、你能駕馭。

### Q：什麼是 GitOps？和傳統推送式 CD 差在哪？
GitOps = 用 **Git 當唯一真實來源**，叢集期望狀態全宣告在 Git，由叢集內 agent（**ArgoCD / Flux**）**持續拉取比對、自動收斂**（reconciliation loop）。

| | 傳統 push 式 CD | GitOps（pull 式）|
|--|--|--|
| 部署觸發 | CI 從外部 push 進叢集 | 叢集 agent 主動 pull |
| 叢集金鑰 | 要交給 CI（外洩風險） | 不用外露，agent 在叢集內 |
| 變更軌跡 | 散在 pipeline log | 全在 Git（PR、審核、歷史）|
| 回滾 | 重跑 pipeline | `git revert` |
| 手動亂改（drift）| 不會自動修正 | agent 自動偵測並修回 |

> **追問「drift 是什麼？」**：有人手動 `kubectl edit` 改了線上，實際狀態偏離 Git。GitOps agent 會偵測到並**自動改回 Git 描述的狀態**，保證環境可重現。

### Q：blue-green vs canary vs rolling？
- **Rolling**：逐批換，無需雙倍資源，但新舊版短暫並存。
- **Blue-green**：新舊兩套完整環境並存，流量**一次性切換**；秒級回滾（切回 blue），代價是**雙倍資源**、DB schema 相容要處理。
- **Canary**：新版先接**一小部分流量（5%→25%→100%）**，配合監控指標逐步放量；風險最小、最適合對用戶敏感的服務，但流程較複雜（需流量切分工具，如 Istio、Argo Rollouts）。

### Q：pipeline 裡怎麼管 secrets？
- 不進 code / Jenkinsfile；用 **Vault / AWS Secrets Manager / K8s Secret（+External Secrets Operator）**。
- CI 執行時**臨時注入**、用完即棄。
- 加 **gitleaks / trufflehog** 掃描，擋住不小心 commit 的金鑰。
- 權限最小化、定期輪替（rotation）。

---

## 3. IaC：Terraform / Ansible

### Q：Terraform 的 state 是什麼？為何重要？團隊怎麼管？
state 是 Terraform 記錄「**我管的資源清單 + 它們當前屬性**」的檔案，是它比對「現況 vs 你寫的 .tf」算出 diff 的依據。
- **不能放本機、不能進 Git**（含明文敏感值 + 會衝突）。
- 放 **remote backend**（S3、Terraform Cloud、GCS）。
- 開 **state locking**（S3 backend 搭 DynamoDB）防止兩人同時 apply 撞爛 state。
- state 加密（backend 支援 encryption at rest）。

> **追問「state 和真實環境不一致怎麼辦？」**：`terraform refresh`（同步）、`terraform import`（把手動建的資源納管）、`terraform state rm/mv`（手術式修 state）。強調**別手動改線上再讓 state 漂移**。

### Q：Terraform vs Ansible？
| | Terraform | Ansible |
|--|--|--|
| 定位 | Provisioning（建基礎設施）| Configuration management（設定既有機器）|
| 風格 | 宣告式（描述最終狀態）| 程序式為主（一步步執行 task）|
| 狀態 | 有 state | 無狀態 |
| 冪等 | 內建 | 靠模組自己保證 |
| 連線 | 呼叫雲 API | 走 SSH / WinRM |

> 「Terraform 蓋房子，Ansible 裝潢。」實務常搭配：Terraform 開好 VM/VPC，Ansible 進去裝軟體。K8s 時代 Ansible 角色縮小（設定改用 container image + ConfigMap）。

### Q：plan 和 apply 差別？怎麼避免誤刪 prod？
`plan` 只**預覽** add/change/**destroy**，不動真的；`apply` 才執行。防誤刪：
- CI 讓 **plan 輸出貼進 PR**，人 review 過才 apply。
- 關鍵資源加 `lifecycle { prevent_destroy = true }`。
- prod 用**獨立 state / 獨立 workspace**，避免動到 dev 波及 prod。
- 看到 plan 有非預期的 `destroy` 就停下——常是改了某個 **ForceNew 屬性**（如改 EC2 的某些欄位會觸發整台重建）。

### Q：怎麼做多環境（dev/staging/prod）分離？
- **module** 抽共用邏輯，各環境傳不同 `tfvars`。
- 各環境**獨立 state 檔**（目錄分離 or workspace）。
- 用 CI + 分支策略控制誰能 apply prod。

---

## 4. 雲端 AWS

### Q：IAM user / role / policy / group？
- **Policy**：JSON 權限清單（Effect allow/deny + Action + Resource + 可加 Condition）。
- **User**：長期身分（代表人），有長期憑證（access key）。
- **Group**：user 的集合，方便一起綁 policy。
- **Role**：**可被臨時 assume 的身分，發臨時憑證（STS）**。給服務用（EC2 instance profile 存取 S3，免寫死金鑰）、跨帳號、或人臨時提權。

> **關鍵字**：role 發臨時憑證、給服務用、免寫死 access key。**最小權限原則**、避免用 root、開 MFA。

### Q：怎麼設計一個安全的 VPC？
- 切 **public subnet**（放對外的 ALB/NAT）與 **private subnet**（放 app、DB）。
- private subnet 要出網（下載更新）走 **NAT Gateway**；完全不需出網的用 **VPC Endpoint** 直連 S3/DynamoDB（不繞公網）。
- **Security Group**（狀態化、綁資源、只有 allow）做細粒度控制；**NACL**（無狀態、綁 subnet、有 allow/deny）做粗粒度。
- 多 AZ、資料庫只開放來自 app SG 的流量、最小開放。

### Q：Security Group vs NACL？
| | Security Group | NACL |
|--|--|--|
| 綁在 | 資源（ENI/EC2）| Subnet |
| 狀態 | **狀態化**（放行進來自動放行回去）| **無狀態**（進出各自要開）|
| 規則 | 只有 allow | allow + deny |
| 評估 | 全部規則一起看 | 依 rule number 由小到大 |

### Q：常用服務 & 成本優化？
挑真的用過的講深。成本：關閉閒置、auto-scaling 按需伸縮、穩定負載買 **Savings Plan/Reserved**、可容錯批次用 **Spot**、S3 生命週期轉冷儲存、用 tag + Cost Explorer 歸因。

---

## 5. 網路與資安基礎

（這家做網通韌體，網路題可能比一般公司深）

### Q：TCP 三次握手 / 四次揮手？
建連：Client **SYN** → Server **SYN-ACK** → Client **ACK**（確認雙向收送能力後建立）。
斷連：**FIN → ACK → FIN → ACK**（四次，因為關閉是雙向各關一次，中間有 TIME_WAIT）。

> **追問「為何三次不是兩次？」**：兩次無法確認 client 的接收能力、且會被延遲的舊 SYN 造成誤連。第三次 ACK 讓雙方都確認對方收得到。

### Q：TCP vs UDP？
TCP 連線導向、可靠（重傳、排序、流量/壅塞控制）、有序，開銷大（HTTP、SSH）；UDP 無連線、不保證送達與順序，但快、低延遲（DNS、影音串流、遊戲）。

### Q：DNS 解析流程？
本機快取/hosts → 遞迴解析器（ISP/8.8.8.8）→ 若無快取則依序問 **root → TLD（.com）→ authoritative NS** → 拿到 A/AAAA 記錄回傳並依 **TTL** 快取。常見記錄：A（IPv4）、AAAA（IPv6）、CNAME（別名）、MX（郵件）、TXT。

### Q：在瀏覽器輸入網址到畫面出現？（經典廣度題）
DNS 解析拿 IP → TCP 三次握手 →（HTTPS 再加 **TLS 握手**：協商加密套件、驗證憑證、交換金鑰）→ 送 HTTP request → 伺服器處理回 response → 瀏覽器解析 HTML、平行抓 CSS/JS/圖 → 建 DOM/CSSOM → layout → paint。把每層點到即可。

### Q（延伸資安）：對稱 vs 非對稱加密？HTTPS 怎麼運作？
非對稱（公私鑰）用來**安全交換對稱金鑰 + 驗證身分（憑證/CA）**，之後用**對稱金鑰**加密實際資料（快）。HTTPS 就是這個組合（TLS）。

---

## 6. 監控與維運

### Q：你怎麼設計監控與告警？
- **Metrics**：Prometheus 拉取 + Grafana 視覺化 + Alertmanager 告警。
- **Logs**：ELK（Elasticsearch/Logstash/Kibana）或 Loki。
- **Tracing**：Jaeger / OpenTelemetry（追分散式請求鏈）。
- 定義 **SLI/SLO**（如 p99 延遲 < 300ms、可用率 99.9%），對關鍵指標設**分級告警**（warning/critical），避免 **alert fatigue**（告警疲勞——太多假警報導致真警報被忽略）。

> **追問「監控四大黃金訊號？」**：**Latency、Traffic、Errors、Saturation**（Google SRE）。或講 USE 法（Utilization/Saturation/Errors）看資源。

### Q：系統效能出問題怎麼排查？
1. **先看監控面板**縮小範圍（哪個服務、哪台、何時開始）。
2. **對照近期變更**——「最近部署了什麼？」（多數事故源於變更，先問這個顯得成熟）。
3. 進機器用 **USE**：CPU、記憶體、磁碟 IO、網路逐層看。
4. 定位是**應用、DB、還是網路**；看 log 與 trace。
5. 止血（回滾/擴容）先於找根因；事後寫 **postmortem**。

### Q：一台 Linux 機器變慢，你下哪些指令？
- `top` / `htop`：CPU、記憶體、哪個 process 吃資源、load average。
- `free -m`：記憶體/swap。
- `df -h` / `du -sh *`：磁碟滿沒、誰佔空間。
- `iostat -x` / `iotop`：磁碟 IO 瓶頸。
- `ss -tunlp` / `netstat`：連線、監聽埠。
- `journalctl -xe` / `dmesg`：系統日誌、有沒有 **OOM killer** 出手。
- `vmstat 1`：整體 CPU/IO/記憶體動態。

> load average 高但 CPU 不忙 → 通常是 **IO wait** 或大量 process 卡在 D 狀態。

---

## 7. Linux / Git

### Q：merge vs rebase？
- **merge**：合併並產生 merge commit，**保留分叉歷史**、不改寫既有 commit。
- **rebase**：把你的 commit 搬到目標分支頂端**重新播放**，歷史變**線性乾淨**，但**改寫了 commit hash**。

> **黃金準則**：**已 push 的公共分支不要 rebase**（改寫歷史害到別人）。本地整理自己的 commit、對 feature 分支同步 main 可以用。`git pull --rebase` 讓歷史更乾淨。

### Q：衝突怎麼解？
Git 標記 `<<<<<<< / ======= / >>>>>>>`，手動編輯選要保留的 → `git add` → `git rebase --continue`（或完成 merge commit）。工具：`git mergetool`、IDE 的三方比對。

### Q（可能）：merge --squash？cherry-pick？reset vs revert？
- **squash**：把一堆 commit 壓成一個再併，歷史乾淨。
- **cherry-pick**：把某個 commit 單獨挑到目前分支。
- **reset**（改指標，會動歷史，本地用）vs **revert**（產生一個反向 commit，安全用於公共分支）。

### Q：設計一個高可用架構（系統設計題）
講骨架：
- **多 AZ 部署**消單點。
- 前面 **Load Balancer** 分流 + 健康檢查。
- 應用層**無狀態 + auto-scaling**（狀態放外部：DB/Redis/S3）。
- 資料庫**主從複製 + 自動 failover**（讀寫分離、加讀取副本）。
- **快取層 Redis** 擋讀取壓力。
- **CDN** 擋靜態資源。
- 監控告警 + 自動化部署可回滾。
> 核心三句：**沒有單點故障、能水平擴展、故障能自動恢復**。

---

## 8. 加分題：IoT / Streaming

### Q：Kafka 的 topic / partition / consumer group？
- **Topic** 切成多個 **partition** 做平行與擴展；partition **內部有序**，跨 partition 不保證全域有序。
- **Producer** 依 key 決定寫哪個 partition（同 key 進同 partition 保有序）。
- **Consumer group**：組內 consumer **分攤 partition**（一個 partition 同時只給組內一個 consumer），要提升吞吐就加 consumer，但**上限 = partition 數**。
- **offset**：消費進度，可控制 at-least-once / at-most-once / exactly-once 語意。

> **誠實策略**：這是 plus 項，沒實作過就說「概念上理解 partition/consumer group/offset，實戰經驗還不多，但很想在這個角色深入 IoT 資料管線」——坦白不扣分，硬拗才扣分。

### Q：Kafka vs 傳統 message queue（RabbitMQ）？
Kafka 是 **append-only log**，訊息可保留、可重播（replay）、高吞吐、適合串流/事件溯源；RabbitMQ 是傳統 broker，強在複雜路由與即時任務分派。IoT 大量裝置資料上報偏 Kafka/Pub-Sub。

---

# Part C：軟性 / 情境題

### Q：為什麼想加入一家剛成立的新公司？（他們最在意）
架構：**認同早期建置機會 + 你要的成長 + 能接受不確定性**。
> 範例：「我目前環境的基礎設施已經很成熟，可改動的空間有限。我想找能**從零參與 CI/CD 與雲端架構設計**的位置，把主導權和影響力放大。新團隊一定有不確定性，但這正是我想要的階段——學得最快，也最能留下自己的東西。」

### Q：遇過最難的 production 事故？
用 **STAR**：情境 → 任務 → 行動 → 結果。講清楚 **症狀 → 怎麼縮小範圍 → 根因 → 怎麼修 → 事後怎麼防再發（postmortem / 加監控 / 改流程）**。重點是**排查邏輯 + 事後改善**，不是英雄主義。

### Q：怎麼和後端、平台團隊協作？（JD 明列）
主動溝通需求、把基礎設施做成**自助服務（self-service）**降低來回、用文件與標準化減摩擦、出事一起 debug 不甩鍋。

### Q：對加班 / on-call 的接受度？
> 「合理範圍的 on-call 和趕交期加班我能接受，這是 DevOps 的一部分。同時我相信**好的自動化和監控能減少半夜被叫起來的次數**，我會往那方向改善。」→ 順勢反問他們實際的加班/on-call 狀況（呼應 Part A）。

### Q：自我介紹 / 為什麼離職？
離職原因**只講正向**（想要更大技術挑戰/成長），**絕不批評前公司**。自我介紹濃縮成「背景 → 專長 → 為何對這職位有興趣」，90 秒內。

---

# 最後提醒

1. **每個技術題準備一個真實案例**——背定義撐不過第二問「你實際怎麼做的」。
2. **不會的誠實說**，補一句「我的理解是…，很想深入學」。DevOps 工具太多，態度比背誦重要。
3. **面試是雙向的**——你答技術題的同時，用 Part A 的問題判斷這家值不值得去。願意坦誠談加班與薪資的公司，本身就是好訊號。
4. **主打建置經驗**：新團隊可能從零建基礎設施，「從無到有搭 pipeline / IaC」的經驗比純維運更對他們胃口。
