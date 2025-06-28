#! /bin/bash

. ../../.env

CLUSTER=$1
if [ -z "$CLUSTER" ]; then
  echo Need cluster
  exit 1
fi

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

argocd app create $CLUSTER-local-path-provisioner \
  --upsert \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path hexcamp-server-prep/20-local-path-provisioner \
  --dest-name $CLUSTER \
  --dest-namespace default
