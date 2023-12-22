#! /bin/bash

. ../../../.env

echo GITHUB_PAT $GITHUB_PAT

VOLUME_HANDLE=$(cd ../terraform; terraform output localnet-farm-efs | sed 's,",,g')

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

set -x

argocd app create localnet-farm-5-knative-jsonnet \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/localnet-farm-5/argocd-efs-jsonnet \
  --dest-name localnet-farm-5 \
  --upsert \
  --jsonnet-tla-str volumeHandle=$VOLUME_HANDLE
