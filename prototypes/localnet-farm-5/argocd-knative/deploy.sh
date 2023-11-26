#! /bin/bash

. ../../../.env

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

argocd app create localnet-farm-5-knative \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/localnet-farm-5/argocd-knative \
  --dest-name localnet-farm-5 \
  --dest-namespace default
