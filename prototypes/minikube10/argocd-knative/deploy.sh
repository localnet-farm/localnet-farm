#! /bin/bash

. ../../../.env

CLUSTER=$(cd ..; pwd | sed 's,^.*\/,,')

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

argocd app create $CLUSTER-knative \
  --upsert \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/$CLUSTER/argocd-knative \
  --dest-name $CLUSTER \
  --dest-namespace default
