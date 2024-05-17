#! /bin/bash

. ../../../.env

echo GITHUB_PAT $GITHUB_PAT

argocd repo add https://github.com/jimpick/localnet-farm.git --username jimpick --password $GITHUB_PAT --upsert

argocd app create localnet-farm-4-dex \
  --repo https://github.com/jimpick/localnet-farm.git \
  --path prototypes/localnet-farm-4/dex \
  --dest-name localnet-farm-4 \
  --dest-namespace default
