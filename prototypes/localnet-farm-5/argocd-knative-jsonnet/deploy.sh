#! /bin/bash

. ../../../.env

echo GITHUB_PAT $GITHUB_PAT

EXTERNAL_IP=$(./get-ip.sh)

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

argocd app create localnet-farm-5-knative-jsonnet \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/localnet-farm-5/argocd-knative-jsonnet \
  --dest-name localnet-farm-5 \
  --dest-namespace countour-external \
  --upsert \
  --jsonnet-tla-str externalIP=$EXTERNAL_IP
