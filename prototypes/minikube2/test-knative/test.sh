#! /bin/bash

# https://knative.dev/docs/getting-started/first-service/

kn service create hello \
--image ghcr.io/knative/helloworld-go:latest \
--port 8080 \
--env TARGET=World

# https://knative.dev/docs/serving/services/custom-domains/

kn domain create hello.v6z.me --ref hello

curl http://hello.default.minikube2.localnet.farm:30080

# Update DNS

curl http://hello.v6z.me:30080/

