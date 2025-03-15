#! /bin/bash

. ../../../.env

CLUSTER=$(cd ..; pwd | sed 's,^.*\/,,')

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

argocd app create $CLUSTER-hierarchical-namespaces \
  --upsert \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/$CLUSTER/hierarchical-namespaces \
  --dest-name $CLUSTER \
  --dest-namespace default
