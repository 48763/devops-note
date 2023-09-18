# EKS note 

```
https://eksctl.io/usage/eks-managed-nodes/
```

runtime 在 1.24 之後，會停止 dockershim 的支援，也就是只有 containerd。

### 節點更新

需要對照 aws 更新表，並且升級時次要版本一次只能差一，並且 EKS control plane 版本和 node 版本也只能差一。

```
$ eksctl upgrade cluster --name my-cluster --approve
```

```
$ eksctl upgrade nodegroup \
    --name=node-group-name \
    --cluster=my-cluster \
    --kubernetes-version=1.23
```

https://docs.aws.amazon.com/eks/latest/userguide/migrate-stack.html

https://docs.aws.amazon.com/eks/latest/userguide/update-stack.html

Fargate

### 更新 alb 控制器

直接解除安裝舊版，再安裝新版即可。

> 不影響原有的 ingress。[[鏈結](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/upgrade/migrate_v1_v2/#upgrade-steps)]
