# minikube3

## Steps

### 1. Deploy using terraform

### 2. Update DNS

```
./update-dns.sh
```

### 3. Update ArgoCD cluster

```
argocd login argocd.infra.hex.camp

argocd cluster rm minikube3

argocd cluster add minikube3 -y
```

### 4. Set up Knative

```
(cd argocd-knative; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/minikube3-knative
```

* https://argocd.infra.hex.camp/applications/minikube3-knative

### 5. Test Knative

```
(cd test-knative; ./test.sh)

curl http://hello.v6z.me:30080/
```

### 6. Add AWS Secrets for Route 53

```
(cd argocd-aws-secrets; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/minikube3-aws-secrets-route53
```

* https://argocd.infra.hex.camp/applications/minikube3-aws-secrets-route53

### 7. Add cert-manager

```
(cd argocd-cert-manager; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/minikube3-cert-manager
```

* https://argocd.infra.hex.camp/applications/minikube3-cert-manager

### 8. Test SSL apps

```
(cd argocd-hello-rootcache; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/minikube3-hello-rootcache

kn domain list

curl https://hello.rootcache.com:30443/

curl https://hello.v6z.me:30443/
```

* https://argocd.infra.hex.camp/applications/minikube3-hello-rootcache
* https://hello.rootcache.com:30443/
* https://hello.v6z.me:30443/

### 9. Demo workloads

```
(cd argocd-workloads; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/minikube3-workloads
```

* https://argocd.infra.hex.camp/applications/minikube3-workloads

/home/centos/storage/coredns-test/Corefile: (change perms to centos)

```
. {
	whoami
	chaos
}
```

```
dig @minikube3.localnet.farm CH version.bind TXT

dig @minikube3.localnet.farm a whoami.example.org
```
