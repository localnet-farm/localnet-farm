#! /bin/bash

. ../../../.env

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

argocd app create minikube1-knative \
  --upsert \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/minikube1/argocd-knative \
  --dest-name minikube1 \
  --dest-namespace default
