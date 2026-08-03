# 題目二: K8s 應用服務

我平常用的是 AKS + Traefik，所以這題照 AKS 的方式做，結構用 Kustomize 分層。

## 怎麼跑

預覽渲染結果: 

```bash
kubectl kustomize k8s/overlayer/uat
```

部署: 

```bash
kubectl apply -k k8s/overlayer/uat
```

### 部署前準備

建立 namespace: 

```bash
kubectl create namespace uat-asiayo
```

## 目錄結構

```
k8s/
├── base/
├── components/
└── overlayer/
```

- base: 應用的基底。
- components: 服務的聚合。
- overlayer: 最終部署至環境的配置。

## 關於高可用

有使用到下面功能: 
- 服務探針
- podAntiAffinity
- PDB
- HPA(cpu + memory)

## 開新環境

overlayer 直接複製一份，base 和 components 完全不用動: 

```bash
cp -r k8s/overlayer/uat k8s/overlayer/prd
```

僅需要修改下面: 

- kustomization.yml: namespace、namePrefix、image tag
- transformer.yml: prefix
- route/ingressRoute.yml: Host
- config/nginx.conf: 有環境差異才需要改

## 沒做的部分

- Terraform(EKS): 我平常在 AKS，要寫出能用的 EKS TF，得先花時間研究 AWS 的細節(網路、IAM、node group)。方向上用 AI(AWS agent + Terraform agent)可以很快生出一版，但沒研究過 AWS 實務，生出來我也判斷不了適不適合，所以不交。
- DB(MySQL StatefulSet): 這塊我不熟，不硬寫。
