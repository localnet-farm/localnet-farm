# minikube1

## Steps

### 1. Deploy using terraform

### 2. Update DNS

```
./update-dns.sh
```

### 3. Update ArgoCD cluster

```
argocd login argocd.infra.hex.camp

argocd cluster rm minikube1

argocd cluster add minikube1 -y
```

### 4. Set up Knative

```
(cd argocd-knative; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/mininet1-knative
```

* https://argocd.infra.hex.camp/applications/mininet1-knative

### 6. Test Knative

```
(cd test-knative; ./test.sh)

curl http://hello.v6z.me:30080/
```

---

### 7. Add AWS Secrets for Route 53

```
(cd argocd-aws-secrets; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/localnet-farm-5-aws-secrets-route53
```

* https://argocd.infra.hex.camp/applications/localnet-farm-5-aws-secrets-route53

### 8. Add cert-manager

```
(cd argocd-cert-manager; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/localnet-farm-5-cert-manager
```

* https://argocd.infra.hex.camp/applications/localnet-farm-5-cert-manager

### 9. Test SSL apps

```
(cd argocd-hello-rootcache; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/localnet-farm-5-hello-rootcache

kn domain list

curl https://hello.rootcache.com:30443/

curl https://hello.v6z.me:30443/
```

* https://argocd.infra.hex.camp/applications/localnet-farm-5-hello-rootcache
* https://hello.rootcache.com:30443/
* https://hello.v6z.me:30443/

### 10. Setup EFS PV

```
(cd argocd-efs-jsonnet; ./deploy.sh)


open https://argocd.infra.hex.camp/applications/localnet-farm-5-efs-jsonnet
```

* https://argocd.infra.hex.camp/applications/localnet-farm-5-efs-jsonnet

### 11. Demo workloads

```
(cd argocd-workloads; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/localnet-farm-5-workloads
```

* https://argocd.infra.hex.camp/applications/localnet-farm-5-workloads
```
