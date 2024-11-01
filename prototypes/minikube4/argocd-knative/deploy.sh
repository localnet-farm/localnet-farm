#! /bin/bash

. ../../../.env

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

argocd app create minikube3-knative \
  --upsert \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/minikube3/argocd-knative \
  --dest-name minikube3 \
  --dest-namespace default
