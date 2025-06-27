# minikube10

## Steps

### 1. Deploy using terraform

### 2. Update DNS

```
./update-dns.sh
```

### 3. Update ArgoCD cluster

```
argocd login argocd.infra.hex.camp

argocd cluster rm minikube10

argocd cluster add minikube10 -y
```

### 4. Set up Knative

```
(cd argocd-knative-dns; ./deploy.sh)

argocd app sync minikube10-knative-dns

open https://argocd.infra.hex.camp/applications/minikube10-knative-dns
```

* https://argocd.infra.hex.camp/applications/minikube10-knative-dns

```
(cd argocd-knative; ./deploy.sh)

argocd app sync minikube10-knative

open https://argocd.infra.hex.camp/applications/minikube10-knative
```

* https://argocd.infra.hex.camp/applications/minikube10-knative

### 5. Test Knative

```
(cd test-knative; ./test.sh)

curl http://hello.v6z.me:30080/
```

### 6. Add AWS Secrets for Route 53

```
(cd argocd-aws-secrets; ./deploy.sh)

argocd app sync minikube10-aws-secrets-route53

open https://argocd.infra.hex.camp/applications/minikube10-aws-secrets-route53
```

* https://argocd.infra.hex.camp/applications/minikube10-aws-secrets-route53

### 7. Add cert-manager

```
(cd argocd-cert-manager; ./deploy.sh)

argocd app sync minikube10-cert-manager

open https://argocd.infra.hex.camp/applications/minikube10-cert-manager
```

* https://argocd.infra.hex.camp/applications/minikube10-cert-manager

### 8. Test SSL apps

```
(cd argocd-hello-rootcache; ./deploy.sh)

argocd app sync minikube10-hello-rootcache

open https://argocd.infra.hex.camp/applications/minikube10-hello-rootcache


kn domain list

curl https://hello.rootcache.com:30443/

curl https://hello.v6z.me:30443/
```

* https://argocd.infra.hex.camp/applications/minikube10-hello-rootcache
* https://hello.rootcache.com:30443/
* https://hello.v6z.me:30443/

### 9. Demo workloads

```
(cd argocd-workloads; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/minikube10-workloads
```

* https://argocd.infra.hex.camp/applications/minikube10-workloads

/home/ubuntu/storage/coredns-test/Corefile: (change perms to ubuntu)

```
. {
  whoami
  chaos
  reload
  log
  errors
  debug
}
```

```
dig @minikube10.localnet.farm CH version.bind TXT

dig @minikube10.localnet.farm a whoami.example.org

```

### 10. local-path-provisioner

### 11. hierarchical-namespaces

