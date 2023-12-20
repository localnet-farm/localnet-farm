# localnet-farm-5

## Steps

### 1. Deploy cluster using Terraform cloud

* https://app.terraform.io/app/hex-camp/workspaces?project=prj-Cm4e7DPMPxRLHkwR

### 2. Setup kubectl

```
export AWS_PROFILE=localnet_farm

aws eks update-kubeconfig --region us-west-2 --name localnet-farm-5
```

### 3. Update DNS

```
./update-dns.sh
```

### 4. Update ArgoCD cluster

```
argocd login argocd.infra.hex.camp

argocd cluster rm localnet-farm-5

argocd cluster add localnet-farm-5 -y
```

### 5. Set up Knative

```
(cd argocd-knative; ./deploy.sh)
```

* https://argocd.infra.hex.camp/applications/localnet-farm-5-knative

### 6. Set IP for Ingress (Countour)

```
(cd argocd-knative-jsonnet; ./deploy.sh)
```

* https://argocd.infra.hex.camp/applications/localnet-farm-5-knative-jsonnet

### 7. Test Knative

```
(cd test-knative; ./test.sh)
```

### 8. Add AWS Secrets for Route 53

```
(cd argocd-aws-secrets; ./deploy.sh)
```

* https://argocd.infra.hex.camp/applications/localnet-farm-5-aws-secrets-provider-quest-route53

### 9. Add cert-manager

```
(cd argocd-cert-manager; ./deploy.sh)
```

* https://argocd.infra.hex.camp/applications/localnet-farm-5-cert-manager



