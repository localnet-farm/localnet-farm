#! /bin/bash

. ../../../.env

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

argocd app create localnet-farm-3-workloads \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/localnet-farm-3/argocd-workloads \
  --dest-name localnet-farm-3 \
  --dest-namespace default
