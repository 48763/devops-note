# Docker 建構安全與私有倉庫認證指南

如何利用 Docker BuildKit 的 Secret 功能，在不洩漏敏感資訊的前提下，於 Docker 建構過程中完成私有倉庫（npm/NuGet）的身份驗證。

## 1. 核心技術：Docker Build Secrets
自 **Docker 18.09** 版本起引入，透過 BuildKit 引擎實作。

* **優勢：** 秘密資訊掛載於記憶體檔案系統（tmpfs），不會寫入鏡像層（Layer），`docker history` 完全不可見。
* **基本語法：**
    * **Dockerfile:**
        ```dockerfile
        # syntax=docker/dockerfile:1
        RUN --mount=type=secret,id=my_secret \
            export TOKEN=$(cat /run/secrets/my_secret) && \
            command_using_token $TOKEN
        ```
    * **Build 指令:**
        ```bash
        docker build --secret id=my_secret,src=./local_file.txt -t my-app .
        ```

## 2. npm 認證實務 (Azure Pipelines)
當專案依賴私有 npm 套件時，結合 Azure Pipeline 任務與 Docker Secret。

### Azure Pipeline 設定
```yaml
steps:
- task: npmAuthenticate@0
  inputs:
    workingFile: .npmrc  # 此任務會自動將臨時 Token 寫入此檔案

- script: |
    docker build --secret id=npmrc,src=.npmrc -t node-app .