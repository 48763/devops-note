# IAM 權限

獲取實例的連結：

```
$ gcloud compute instances list --filter=NAME:<instance-name> --uri
https://www.googleapis.com/compute/v1/projects/<project-id>/zones/asia-east1-b/instances/<instance-name>
```


獲取該實例的權限：

```
$ gcloud iam list-testable-permissions https://www.googleapis.com/compute/v1/projects/<project-id>/zones/asia-east1-b/instances/<instance-name>
$ gcloud iam list-testable-permissions //compute.googleapis.com/projects/<project-id>/zones/asia-east1-b/instances/<instance-name>
```

創建服務帳號，並獲取其 e-mail：

```
$ gcloud iam service-accounts create <name>
$ gcloud iam service-accounts list --filter="name:<name>" --format="value(email)"
```

綁定權限至服務帳號：

```
$ gcloud projects add-iam-policy-binding --member serviceAccount:<service-account> \
    --role roles/iam.serviceAccountUser <project>
```

> roles/compute.instanceAdmin, roles/compute.networkAdmin, roles/iam.serviceAccountUser

檢查專案內的權限分配：

```
gcloud projects get-iam-policy <project>
```

將服務帳號賦予給其它帳號：

```
$ gcloud iam service-accounts add-iam-policy-binding --member serviceAccount:<service-account> \
    --role <role> <project>
```