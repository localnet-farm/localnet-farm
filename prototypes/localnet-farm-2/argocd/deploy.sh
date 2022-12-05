#! /bin/bash

. ../../../.env

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

argocd app create localnet-farm-2 \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/localnet-farm-2/argocd \
  --dest-name localnet-farm-2 \
  --dest-namespace default
