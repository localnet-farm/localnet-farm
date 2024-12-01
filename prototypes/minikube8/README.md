# minikube8

## Steps

### 1. Deploy using terraform

### 2. Update DNS

```
./update-dns.sh
```

### 3. Update ArgoCD cluster

```
argocd login argocd.infra.hex.camp

argocd cluster rm minikube8

argocd cluster add minikube8 -y
```

### 4. Set up Knative

```
(cd argocd-knative-dns; ./deploy.sh)

argocd app sync minikube8-knative-dns

open https://argocd.infra.hex.camp/applications/minikube8-knative-dns
```

* https://argocd.infra.hex.camp/applications/minikube8-knative-dns

```
(cd argocd-knative; ./deploy.sh)

argocd app sync minikube8-knative

open https://argocd.infra.hex.camp/applications/minikube8-knative
```

* https://argocd.infra.hex.camp/applications/minikube8-knative

### 5. Test Knative

```
(cd test-knative; ./test.sh)

curl http://hello.v6z.me:30080/
```

### 6. Add AWS Secrets for Route 53

```
(cd argocd-aws-secrets; ./deploy.sh)

argocd app sync minikube8-aws-secrets-route53

open https://argocd.infra.hex.camp/applications/minikube8-aws-secrets-route53
```

* https://argocd.infra.hex.camp/applications/minikube8-aws-secrets-route53

### 7. Add cert-manager

```
(cd argocd-cert-manager; ./deploy.sh)

argocd app sync minikube8-cert-manager

open https://argocd.infra.hex.camp/applications/minikube8-cert-manager
```

* https://argocd.infra.hex.camp/applications/minikube8-cert-manager

### 8. Test SSL apps

```
(cd argocd-hello-rootcache; ./deploy.sh)

argocd app sync minikube8-hello-rootcache

open https://argocd.infra.hex.camp/applications/minikube8-hello-rootcache


kn domain list

curl https://hello.rootcache.com:30443/

curl https://hello.v6z.me:30443/
```

* https://argocd.infra.hex.camp/applications/minikube8-hello-rootcache
* https://hello.rootcache.com:30443/
* https://hello.v6z.me:30443/

### 9. Demo workloads

```
(cd argocd-workloads; ./deploy.sh)

open https://argocd.infra.hex.camp/applications/minikube8-workloads
```

* https://argocd.infra.hex.camp/applications/minikube8-workloads

/home/ubuntu/storage/coredns-test/Corefile: (change perms to ubuntu)

```
. {
	whoami
	chaos
}
```

```
dig @minikube8.localnet.farm CH version.bind TXT

dig @minikube8.localnet.farm a whoami.example.org
```
