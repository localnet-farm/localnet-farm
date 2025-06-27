#! /bin/bash

. ../../.env
. .env

CLUSTER=$1
if [ -z "$CLUSTER" ]; then
  echo Need cluster
  exit 1
fi

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

kubectl create ns knative-serving

argocd app create $CLUSTER-knative-dns \
  --upsert \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/$CLUSTER/argocd-knative-dns \
  --dest-name $CLUSTER \
  --dest-namespace default \
  --jsonnet-tla-str hostname="$CLUSTER.localnet.farm"

